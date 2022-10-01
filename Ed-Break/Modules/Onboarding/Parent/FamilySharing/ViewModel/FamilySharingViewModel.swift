//
//  FamilySharingViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

final class FamilySharingViewModel: FamilySharingViewModeling, Identifiable {
    
    private var addParentUseCase: AddParentUseCase
    private let localStorageService: LocalStorageService
    
    init(addParentUseCase: AddParentUseCase, localStorageService: LocalStorageService) {
        self.addParentUseCase = addParentUseCase
        self.localStorageService = localStorageService
    }
    
    func addParent() {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        addParentUseCase.execute(username: deviceId) { [weak self] result in
            switch result {
            case .success(let token):
                self?.localStorageService.setObject(token, forKey: .User.token)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


// MARK: - Preview

final class MockFamilySharingViewModel: FamilySharingViewModeling, Identifiable {
    
    func addParent() { }
}
