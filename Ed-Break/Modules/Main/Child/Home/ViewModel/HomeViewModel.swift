//
//  HomeViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//

import UIKit
import FamilyControls

final class HomeViewModel: HomeViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    @Published var contentModel: HomeModel? = nil
    
    @Published var remindingMinutes: Int = 0 {
        didSet {
            progress = Double(self.remindingMinutes)/Double(contentModel?.interruption ?? 1)
        }
    }
    @Published var progress: Double = 0
    
    private var didUpdateToken = false
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
                    guard let self = self else { return }
                    self.contentModel = model
                    let today = Date()
                    if let restrictions = model.restrictions {
                        if let startTime = model.breakStartDatetime,
                           let endTime = model.breakEndDatetime,
                           startTime.component(.day) == today.component(.day),
                           startTime.component(.hour) ?? 0 <= today.component(.hour) ?? 0,
                           startTime.component(.minute) ?? 0 <= today.component(.minute) ?? 0,
                           endTime > today {
                            let difference = self.getMinutes(start: endTime) ?? 0
                            self.remindingMinutes = difference < 0 ? 0-difference : 0
                            DataModel.shared.threshold = DateComponents(minute: self.remindingMinutes)
                            DataModel.shared.selectionToEncourage = restrictions
                        } else {
                            DataModel.shared.selectionToDiscourage = restrictions
                            self.remindingMinutes = 0
                        }
                        DataModel.shared.setShieldRestrictions()
                    } else {
                        DataModel.shared.selectionToDiscourage = FamilyActivitySelection()
                        self.remindingMinutes = 0
                        DataModel.shared.setShieldRestrictions()
                    }
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
        let diff = Int(Date().timeIntervalSince1970 - start.timeIntervalSince1970)
        
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        return minutes
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
