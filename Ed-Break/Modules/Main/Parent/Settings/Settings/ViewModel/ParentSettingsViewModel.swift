//
//  ParentSettingsViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import UIKit

final class ParentSettingsViewModel: ParentSettingsViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    var isUserLoggedIn: Bool {
        UserDefaultsService().getPrimitive(forKey: .User.isLoggedIn) ?? false
    }
    
    private var deleteParentUseCase: DeleteParentUseCase
    private let localStorageService: LocalStorageService
    
    init(deleteParentUseCase: DeleteParentUseCase, localStorageService: LocalStorageService) {
        self.deleteParentUseCase = deleteParentUseCase
        self.localStorageService = localStorageService
    }
    
    func deleteAccount(completion: @escaping ()->()) {
        isLoading = true
        deleteParentUseCase.execute { [weak self] error in
            DispatchQueue.main.async { self?.isLoading = false }
            if let error = error { print(error.localizedDescription); return }
            self?.localStorageService.remove(key: .User.token)
            self?.localStorageService.remove(key: .ChildUser.token)
            self?.localStorageService.remove(key: .User.isLoggedIn)
            self?.localStorageService.remove(key: .ChildUser.isLoggedIn)
            completion()
        }
    }
}


// MARK: - Preview

final class MockParentSettingsViewModel: ParentSettingsViewModeling, Identifiable {
    
    var isLoading = false
    let isUserLoggedIn: Bool = false
    
    func deleteAccount(completion: @escaping ()->()) { }
}
