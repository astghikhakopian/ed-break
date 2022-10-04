//
//  ChildrenViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import UIKit

final class ChildrenViewModel: ChildrenViewModeling, Identifiable {
    
    @Published var children = PagingModel<ChildModel>(results: [])
    @Published var isLoading: Bool = false
    
    private var getChildrenUseCase: GetChildrenUseCase
    
    init(getChildrenUseCase: GetChildrenUseCase) {
        self.getChildrenUseCase = getChildrenUseCase
    }
    
    func getChildren() {
        isLoading = true
        getChildrenUseCase.execute { result in
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let models):
                DispatchQueue.main.async { [weak self] in
                    self?.children = PagingModel(results: models)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}


// MARK: - Preview

final class MockChildrenViewModeling: ChildrenViewModeling, Identifiable {
    
    var isLoading = false
    var children = PagingModel<ChildModel>(results: [])
    func getChildren() { }
}
