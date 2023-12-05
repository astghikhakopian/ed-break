//
//  OfflineChildGettingViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.08.23.
//

import SwiftUI
import Combine
import CoreData
import FamilyControls

final class OfflineChildGettingViewModel: OfflineChildGettingViewModeling {
    
    @Published var isLoading: Bool = false
    @Published var contentModel: OfflineChildModel?
    
    @Published var remindingMinutes: Int = 0 {
        didSet {
            progress = Double(self.remindingMinutes)/Double(contentModel?.interruption ?? 1)
        }
    }
    @Published var progress: Double = 0
    @Published var shouldShowExercises: Bool = false
    @Published var shieldSeconds: Int = 0
    
    var doingSubject: OfflineSubjectModel? {
        let subjects = contentModel?.childSubjects
        return subjects?.randomElement()
        // return subjects?.first(where: { $0.answeredQuestionsCount > 0 && !$0.completed }) ?? subjects?.randomElement()
    }
    var isActiveWrongAnswersBlock: Bool {
        shieldSeconds > 0
    }
    private var timer: Timer?
    
    private let getOfflineChildUseCase: GetOfflineChildUseCase
    private let updateBreakDateOfflineChildUseCase: UpdateBreakDateOfflineChildUseCase
    private let context: NSManagedObjectContext
    private let userDefaultsService = UserDefaultsService()
    
    private var cancelables = Set<AnyCancellable>()
    
    init(
        offlineChildProviderProtocol: OfflineChildProvideerProtocol,
        context: NSManagedObjectContext
    ) {
        self.getOfflineChildUseCase = GetOfflineChildUseCase(offlineChildProvider: offlineChildProviderProtocol)
        self.updateBreakDateOfflineChildUseCase = UpdateBreakDateOfflineChildUseCase(offlineChildProvider: offlineChildProviderProtocol)
        self.context = context
    }
    
    func getSubjects() {
        isLoading = true
        getOfflineChildUseCase.execute(in: context)
            .sink { result in
                DispatchQueue.main.async { [weak self] in self?.isLoading = false }
                switch result {
                case .finished: break
                case .failure: break
                }
            } receiveValue: { [weak self] mo in
                DispatchQueue.main.async { [weak self] in
                    let contentModel = OfflineChildModel(mo: mo)
                    self?.contentModel = contentModel
                    self?.processModel(model: contentModel)
                }
            }.store(in: &cancelables)
    }

    
    private func processModel(model: OfflineChildModel) {
        let allremindingMinutes: Int? = self.userDefaultsService.getPrimitiveFromSuite(forKey: .ChildUser.remindingMinutes)
        let restrictions = model.restrictionsObject ?? FamilyActivitySelection()
        
        if let wrongAnswersTime = contentModel?.wrongAnswersDate?.toLocal() {
            if let difference = getSeconds(start: wrongAnswersTime),
               difference < 0 {
                if -difference > 5 {
                    
                }
                shieldSeconds = -difference
                startShieldTimer()
            }
        }
        
        if let _ = model.breakStartDate?.toLocalTime() {
            self.remindingMinutes = model.interruption ?? 0
            nullifyBreakTime()
        } else if
            let allremindingMinutes = allremindingMinutes,
            allremindingMinutes > 0 {
            self.remindingMinutes = allremindingMinutes
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
        
        let shouldShowExercises: Bool? = self.userDefaultsService.getPrimitive(forKey: .ChildUser.shouldShowExercises)
        self.shouldShowExercises = shouldShowExercises ?? false
        userDefaultsService.setPrimitive(false, forKey: .ChildUser.shouldShowExercises)
    }
    
    private func nullifyBreakTime() {
        updateBreakDateOfflineChildUseCase.execute(date: nil, in: context)
            .sink { result in
                switch result {
                case .finished: break
                case .failure: break
                }
            } receiveValue: { success in
                print(success)
            }.store(in: &cancelables)
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
