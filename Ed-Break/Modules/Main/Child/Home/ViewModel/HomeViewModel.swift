//
//  HomeViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//

import FamilyControls
import SwiftUI
import Combine

final class HomeViewModel: HomeViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    @Published var contentModel: HomeModel? = nil
    
    @Published var remindingMinutes: Int = 0 {
        didSet {
            progress = Double(self.remindingMinutes)/Double(contentModel?.interruption ?? 1)
        }
    }
    @Published var progress: Double = 0
    
    @Published var shieldSeconds: Int = 0
    @Published var shouldShowExercises: Bool = false
    
    var isActiveWrongAnswersBlock: Bool {
        shieldSeconds > 0
    }
    
    private var timer: Timer?
    private var didUpdateToken = false
    private let userDefaultsService = UserDefaultsService()
    private var getSubjectsUseCase: GetSubjectsUseCase
    private let checkConnectionUseCase: CheckConnectionUseCase
    
    private var cancelables = Set<AnyCancellable>()
    
    
    init(getSubjectsUseCase: GetSubjectsUseCase, checkConnectionUseCase: CheckConnectionUseCase) {
        self.getSubjectsUseCase = getSubjectsUseCase
        self.checkConnectionUseCase = checkConnectionUseCase
    }
    
    func getSubjects() {
        isLoading = true
        getSubjectsUseCase.execute { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.processModel(model: model)
                }
            case .failure(let failure):
                self.checkConnection { success in
                    guard success else { return }
                    DispatchQueue.main.async {
                        self.getSubjects()
                    }
                }
                print(failure.localizedDescription)
            }
        }
    }
    
    func checkConnection(compleated: @escaping (Bool)->()) {
        guard !didUpdateToken else { return }
        didUpdateToken = true
        DispatchQueue.main.async { self.isLoading = true }
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        let name = UIDevice.current.name
        let model = UIDevice.modelName
        checkConnectionUseCase.execute(
            payload: PairChildPayload(
                id: -1,
                deviceToken: uuid,
                childDeviceName: name,
                childDeviceModel: model
            )
        ) { [weak self] result in
            switch result {
            case .success(let token):
                let localStorageService = UserDefaultsService()
                localStorageService.setObject(token, forKey: .ChildUser.token)
                localStorageService.setPrimitive(true, forKey: .ChildUser.isLoggedIn)
                compleated(true)
                DispatchQueue.main.async { self?.isLoading = false }
            case .failure(let failure):
                compleated(false)
                print(failure.localizedDescription)
            }
        }
    }
    
    private func processModel(model: HomeModel) {
        var model = model
        model.wrongAnswersTime = (model.wrongAnswersTime ?? Date().toLocalTime()) > Date().toLocalTime()
        ? model.wrongAnswersTime
        : nil
        self.contentModel = model
        let today = Date().toLocalTime()
        let allremindingMinutes: Int? = self.userDefaultsService.getPrimitiveFromSuite(forKey: .ChildUser.remindingMinutes)
        let restrictions = model.restrictions ?? FamilyActivitySelection()
        
        if let wrongAnswersTime = contentModel?.wrongAnswersTime {
            if let difference = getSeconds(start: wrongAnswersTime),
               difference < 0 {
                shieldSeconds = -difference
                startShieldTimer()
            }
        }
        
        if let startTime = model.breakStartDatetime /*,
           startTime.component(.day) == today.component(.day),
           startTime.component(.hour) ?? 0 <= today.component(.hour) ?? 0*/ {
            
            let startTimeMinute = startTime.component(.minute) ?? 0
            let todayMinute = today.component(.minute) ?? 0
            
            if startTimeMinute == todayMinute {
                self.remindingMinutes = model.interruption ?? 0
            } else if
                startTimeMinute < todayMinute,
                let allremindingMinutes = allremindingMinutes,
                allremindingMinutes > 0 {
                self.remindingMinutes = allremindingMinutes
            } else {
                self.remindingMinutes = allremindingMinutes ?? 0
            }
        } else {
            self.remindingMinutes = allremindingMinutes ?? 0
        }
        
        let shouldRestrict = self.remindingMinutes <= 0
        DataModel.shared.threshold = shouldRestrict ? DateComponents() : DateComponents(minute: 1)
        DataModel.shared.selectionToEncourage = shouldRestrict ? FamilyActivitySelection() : restrictions
        DataModel.shared.selectionToDiscourage = shouldRestrict ? restrictions : FamilyActivitySelection()
        DataModel.shared.remindingMinutes = self.remindingMinutes
        DataModel.shared.setShieldRestrictions()
        
        self.userDefaultsService.setPrimitiveInSuite(self.remindingMinutes, forKey: .ChildUser.remindingMinutes)
        self.userDefaultsService.setObjectInSuite(DataModel.shared.threshold, forKey: .ChildUser.threshold)
        self.userDefaultsService.setObjectInSuite(DataModel.shared.selectionToEncourage, forKey: .ChildUser.selectionToEncourage)
        self.userDefaultsService.setObjectInSuite(DataModel.shared.selectionToDiscourage, forKey: .ChildUser.selectionToDiscourage)
        ScheduleModel.setSchedule()
        
        let shouldShowExercises: Bool? = self.userDefaultsService.getPrimitive(forKey: .ChildUser.shouldShowExercises)
        self.shouldShowExercises = shouldShowExercises ?? false
        userDefaultsService.setPrimitive(false, forKey: .ChildUser.shouldShowExercises)
    }
    
    private func getSeconds(start: Date?) -> Int? {
        guard let start = start else { return nil }
        let diff = Int(Date().toLocalTime().timeIntervalSince1970 - start.timeIntervalSince1970)
        
        let hours = diff / 3600
        let minutes = (diff - hours * 3600)
        return minutes
    }
    
    private func startShieldTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
                  guard self.shieldSeconds > 0 else {
                self.timer?.invalidate();
                self.timer = nil
                return
                
            }
            self.shieldSeconds -= 1
        }
    }
}


// MARK: - Preview

final class MockHomeViewModel: HomeViewModeling, Identifiable {
    
    var isActiveWrongAnswersBlock: Bool = false
    var shieldSeconds: Int = 0
    var shouldShowExercises = false
    
    var isLoading = false
    var remindingMinutes: Int = 0
    var progress: Double = 0
    var contentModel: HomeModel?
    
    func getSubjects() { }
    func checkConnection(compleated: @escaping (Bool)->()) { }
}
