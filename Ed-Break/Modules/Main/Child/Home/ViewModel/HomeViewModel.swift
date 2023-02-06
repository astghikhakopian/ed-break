//
//  HomeViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//

import UIKit
import FamilyControls
import SwiftUI

final class HomeViewModel: HomeViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    @Published var contentModel: HomeModel? = nil
    
    @Published var remindingMinutes: Int = 0 {
        didSet {
            progress = Double(self.remindingMinutes)/Double(contentModel?.interruption ?? 1)
            
//            let threshold = DateComponents(minute: remindingMinutes > 1 ? remindingMinutes-1 : 0)
//            self.userDefaultsService.setObjectInSuite(threshold, forKey: .ChildUser.threshold)
            
//            ScheduleModel.setSchedule()
        }
    }
    @Published var progress: Double = 0
    
    private var didUpdateToken = false
    private let userDefaultsService = UserDefaultsService()
    private var getSubjectsUseCase: GetSubjectsUseCase
    private let checkConnectionUseCase: CheckConnectionUseCase
    
    
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
    
    private func getMinutes(start: Date?) -> Int? {
        guard let start = start else { return nil }
        let diff = Int(Date().toLocalTime().timeIntervalSince1970 - start.timeIntervalSince1970)
        
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        return minutes
    }
    
    private func processModel(model: HomeModel) {
        var model = model
        model.wrongAnswersTime = (model.wrongAnswersTime ?? Date().toLocalTime()) > Date().toLocalTime()
        ? model.wrongAnswersTime
        : nil
        self.contentModel = model
        let today = Date().toLocalTime()
        if let restrictions = model.restrictions {
            if let startTime = model.breakStartDatetime,
               let endTime = model.breakEndDatetime,
               startTime.component(.day) == today.component(.day),
               startTime.component(.hour) ?? 0 <= today.component(.hour) ?? 0,
               startTime.component(.minute) ?? 0 <= today.component(.minute) ?? 0,
               endTime > today {
                let allremindingMinutes: Int? = self.userDefaultsService.getPrimitiveFromSuite(forKey: .ChildUser.remindingMinutes) //self.getMinutes(start: endTime) ?? 0
                let difference = allremindingMinutes ?? model.interruption ?? 0
                self.remindingMinutes = difference //difference < 0 ? (0-difference)+1 : 0
                
                DataModel.shared.threshold = DateComponents(minute: self.remindingMinutes-1)
                DataModel.shared.selectionToEncourage = restrictions
                DataModel.shared.selectionToDiscourage = FamilyActivitySelection()
                DataModel.shared.setShieldRestrictions()
                
                let threshold = DateComponents(minute: self.remindingMinutes > 1 ? self.remindingMinutes-1 : 0)
                self.userDefaultsService.setObjectInSuite(threshold, forKey: .ChildUser.threshold)
                self.userDefaultsService.setObjectInSuite(restrictions, forKey: .ChildUser.selectionToEncourage)
                self.userDefaultsService.setObjectInSuite(FamilyActivitySelection(), forKey: .ChildUser.selectionToDiscourage)
                self.userDefaultsService.setPrimitiveInSuite(model.interruption ?? 0, forKey: .ChildUser.remindingMinutes)
                
                ScheduleModel.setSchedule()
                // ScheduleModel.setSchedule(startTime: model.breakStartDatetime)
            } else {
                DataModel.shared.selectionToDiscourage = restrictions
                DataModel.shared.selectionToEncourage = FamilyActivitySelection()
                DataModel.shared.threshold = DateComponents()
                DataModel.shared.setShieldRestrictions()

                self.remindingMinutes = 0
                
                self.userDefaultsService.setObjectInSuite(DateComponents(), forKey: .ChildUser.threshold)
                self.userDefaultsService.setObjectInSuite(FamilyActivitySelection(), forKey: .ChildUser.selectionToEncourage)
                self.userDefaultsService.setObjectInSuite(restrictions, forKey: .ChildUser.selectionToDiscourage)
                
                ScheduleModel.setSchedule()
            }
        } else {
            DataModel.shared.selectionToDiscourage = FamilyActivitySelection()
            DataModel.shared.selectionToEncourage = FamilyActivitySelection()
            DataModel.shared.threshold = DateComponents()
            DataModel.shared.setShieldRestrictions()
            
            self.remindingMinutes = 0
            
            self.userDefaultsService.setObjectInSuite(DateComponents(), forKey: .ChildUser.threshold)
            self.userDefaultsService.setObjectInSuite(FamilyActivitySelection(), forKey: .ChildUser.selectionToEncourage)
            self.userDefaultsService.setObjectInSuite(FamilyActivitySelection(), forKey: .ChildUser.selectionToDiscourage)
            
            ScheduleModel.setSchedule()
        }
        DataModel.shared.remindingMinutes = self.remindingMinutes
    }
}


// MARK: - Preview

final class MockHomeViewModel: HomeViewModeling, Identifiable {
    var isLoading = false
    var remindingMinutes: Int = 0
    var progress: Double = 0
    var contentModel: HomeModel?
    
    func getSubjects() { }
    func checkConnection(compleated: @escaping (Bool)->()) { }
    func setRestrictions() { }
}
