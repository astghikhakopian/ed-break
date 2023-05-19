//
//  HomeViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//

import UIKit
import FamilyControls
import SwiftUI
import Combine

final class HomeViewModel: HomeViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    @Published var contentModel: HomeModel? = nil
    
    @Published var isNavigationAllowed: Bool = false
    
    @Published var remindingMinutes: Int = 0 {
        didSet {
            progress = Double(self.remindingMinutes)/Double(contentModel?.interruption ?? 1)
        }
    }
    @Published var progress: Double = 0
    
    private var didUpdateToken = false
    private let userDefaultsService = UserDefaultsService()
    private var getSubjectsUseCase: GetSubjectsUseCase
    private let checkConnectionUseCase: CheckConnectionUseCase
    
    private var cancelables = Set<AnyCancellable>()
    private var isRecoverModelVaid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($contentModel,$isLoading)
            .map { [weak self] contentModel, isLoading in
                self?.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime()
            }.eraseToAnyPublisher()
    }
    
    
    init(getSubjectsUseCase: GetSubjectsUseCase, checkConnectionUseCase: CheckConnectionUseCase) {
        self.getSubjectsUseCase = getSubjectsUseCase
        self.checkConnectionUseCase = checkConnectionUseCase
        isRecoverModelVaid
            .receive(on: RunLoop.main)
            .assign(to: \.isNavigationAllowed, on: self)
            .store(in: &cancelables)
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
    
    func setRestrictions() {
        DataModel.shared.selectionToDiscourage = contentModel?.restrictions ?? FamilyActivitySelection()
        DataModel.shared.setShieldRestrictions()
    }
    
    func checkConnection(compleated: @escaping (Bool)->()) {
        guard !didUpdateToken else { return }
        didUpdateToken = true
        isLoading = true
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        
        checkConnectionUseCase.execute(payload: PairChildPayload(id: -1, deviceToken: uuid)) { [weak self] result in
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
        
        if let startTime = model.breakStartDatetime,
           startTime.component(.day) == today.component(.day),
           startTime.component(.hour) ?? 0 <= today.component(.hour) ?? 0 {
            
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
                self.remindingMinutes = 0
            }
        } else {
            self.remindingMinutes = 0
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
    }
}


// MARK: - Preview

final class MockHomeViewModel: HomeViewModeling, Identifiable {
    var isNavigationAllowed: Bool = false
    
    var isLoading = false
    var remindingMinutes: Int = 0
    var progress: Double = 0
    var contentModel: HomeModel?
    
    func getSubjects() { }
    func checkConnection(compleated: @escaping (Bool)->()) { }
    func setRestrictions() { }
}
