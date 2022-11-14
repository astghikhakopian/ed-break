//
//  HomeViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//

import UIKit

final class HomeViewModel: HomeViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    @Published var contentModel: HomeModel? = nil
    
    private var getSubjectsUseCase: GetSubjectsUseCase
    
    init(getSubjectsUseCase: GetSubjectsUseCase) {
        self.getSubjectsUseCase = getSubjectsUseCase
    }
    
    func getSubjects() {
        isLoading = true
        getSubjectsUseCase.execute { result in
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.contentModel = model
                    if let restrictions = model.restrictions {
                        DataModel.shared.selectionToDiscourage = restrictions
                        DataModel.shared.setShieldRestrictions()
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}


// MARK: - Preview

final class MockHomeViewModel: HomeViewModeling, Identifiable {
    var isLoading = false
    var contentModel: HomeModel? = nil
    func getSubjects() { }
}
