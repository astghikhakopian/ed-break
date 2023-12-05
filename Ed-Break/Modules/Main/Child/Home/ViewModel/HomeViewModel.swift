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
    @Published var didSubjectsLoad: Bool = true
    @Published var questionBlockError: QuestionBlockError?
    @Published var contentModel: HomeModel? = nil
    
    @Published var remindingMinutes: Int = 0 {
        didSet {
            progress = Double(self.remindingMinutes)/Double(contentModel?.interruption ?? 1)
        }
    }
    @Published var progress: Double = 0
    
    @Published var shieldSeconds: Int = 1
    @Published var shouldShowExercises: Bool = false
    
    var doingSubject: SubjectModel? {
        let subjects = contentModel?.subjects
        return subjects?.first(where: { $0.doExercise }) ?? subjects?.randomElement()
    }
    
    var isActiveWrongAnswersBlock: Bool {
        questionBlockError?.blockedTime ?? 0 > 0
    }
    
    private var timer: Timer?
    private var didUpdateToken = false
    private let userDefaultsService = UserDefaultsService()
    private var getSubjectsUseCase: GetSubjectsUseCase
    private let getQuestionsUseCase: GetQuestionsUseCase
    private let checkConnectionUseCase: CheckConnectionUseCase
    
    private var cancelables = Set<AnyCancellable>()
    
    
    init(
        getSubjectsUseCase: GetSubjectsUseCase,
        getQuestionsUseCase: GetQuestionsUseCase,
        checkConnectionUseCase: CheckConnectionUseCase
    ) {
        self.getSubjectsUseCase = getSubjectsUseCase
        self.getQuestionsUseCase = getQuestionsUseCase
        self.checkConnectionUseCase = checkConnectionUseCase
    }
    
    func getSubjects() {
        guard didSubjectsLoad else { return }
        isLoading = true
        didSubjectsLoad = false
        getSubjectsUseCase.execute { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.didSubjectsLoad = true
            }
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
    
    func getQuestions(completion: @escaping ((QuestionsContainerModel?, QuestionBlockError?)) -> Void) {
        guard let doingSubject = doingSubject else { return }
        isLoading = true
        getQuestionsUseCase.execute(subjectId: doingSubject.id) { result in
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let model):
                completion((model, nil))
            case .failure(let failure):
                DispatchQueue.main.async { [weak self] in
                    if let error = failure as? QuestionBlockError {
                        self?.questionBlockError = error
                        //                    self?.shieldSeconds = error?.blockedTime ?? 0
                        self?.startShieldTimer()
                        completion((nil, error))
                    }
                }
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
        self.contentModel = model
        let today = Date().toLocalTime()
        let allremindingMinutes: Int? = self.userDefaultsService.getPrimitiveFromSuite(forKey: .ChildUser.remindingMinutes)
        let restrictions = model.restrictions ?? FamilyActivitySelection()
        
        if let startTime = model.breakStartDatetime, (allremindingMinutes ?? 0) <= 0 {
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
    
//    private func getSeconds(start: Date?) -> Int? {
//        guard let start = start else { return nil }
//        let diff = Int(Date().toLocalTime().timeIntervalSince1970 - start.timeIntervalSince1970)
//
//        let hours = diff / 3600
//        let minutes = (diff - hours * 3600)
//        return minutes
//    }
    
    private func startShieldTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard let shieldSeconds = self.questionBlockError?.blockedTime, shieldSeconds > 0 else {
                self.timer?.invalidate();
                self.timer = nil
                return
                
            }
            
            self.questionBlockError?.blockedTime = shieldSeconds - 1
        }
    }
}


// MARK: - Preview

final class MockHomeViewModel: HomeViewModeling, Identifiable {
    var questionBlockError: QuestionBlockError?
    var doingSubject: SubjectModel? = nil
    var isActiveWrongAnswersBlock: Bool = false
    var shieldSeconds: Int = 0
    var shouldShowExercises = false
    
    var isLoading = false
    var remindingMinutes: Int = 0
    var progress: Double = 0
    var contentModel: HomeModel?
    
    func getSubjects() { }
    func getQuestions(completion: @escaping ((QuestionsContainerModel?, QuestionBlockError?)) -> Void) { }
    func checkConnection(compleated: @escaping (Bool)->()) { }
}
