//
//  FamilySharingViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

final class FamilySharingViewModel: FamilySharingViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    
    private var addParentUseCase: AddParentUseCase
    private let localStorageService: LocalStorageService
    
    init(addParentUseCase: AddParentUseCase, localStorageService: LocalStorageService) {
        self.addParentUseCase = addParentUseCase
        self.localStorageService = localStorageService
    }
    
    func addParent() {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        isLoading = true
        addParentUseCase.execute(username: deviceId) { [weak self] result in
            DispatchQueue.main.async { self?.isLoading = false }
            switch result {
            case .success(let token):
                self?.localStorageService.setObject(token, forKey: .User.token)
                self?.localStorageService.setPrimitive(true, forKey: .User.isLoggedIn)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


// MARK: - Preview

final class MockFamilySharingViewModel: FamilySharingViewModeling, Identifiable {
    
    var isLoading = false
    
    func addParent() { }
}
