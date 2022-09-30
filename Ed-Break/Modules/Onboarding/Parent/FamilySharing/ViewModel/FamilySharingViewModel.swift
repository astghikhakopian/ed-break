//
//  FamilySharingViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

final class FamilySharingViewModel: FamilySharingViewModeling, Identifiable {
    
    private var addParentUseCase: AddParentUseCase
    
    init(addParentUseCase: AddParentUseCase) {
        self.addParentUseCase = addParentUseCase
    }
    
    func addParent() {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        addParentUseCase.execute(username: deviceId) { result in
            switch result {
            case .success(let success):
                print(success)
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
