//
//  ChildrenViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import UIKit

final class ChildrenViewModel: ChildrenViewModeling, Identifiable {
    
//    var children: PagingModel<ChildModel> {
//        childrenLocal
//    }
    @Published var children = PagingModel<ChildModel>(results: [])
    
    private var getChildrenUseCase: GetChildrenUseCase
    
    init(getChildrenUseCase: GetChildrenUseCase) {
        self.getChildrenUseCase = getChildrenUseCase
    }
    
    func getChildren() {
        getChildrenUseCase.execute { result in
            switch result {
            case .success(let models):
                DispatchQueue.main.async { [weak self] in
                    self?.children = PagingModel(results: models)
//                    self?.childrenrLocal.objectWillChange.send()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}


// MARK: - Preview

final class MockChildrenViewModeling: ChildrenViewModeling, Identifiable {
    
    var children = PagingModel<ChildModel>(results: [])
    func getChildren() { }
}
