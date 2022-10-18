//
//  ChildDetailsViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

class ChildDetailsModel {
    var id: UUID = UUID()
    @Published var image = UIImage()
    var grade: Grade = .first
    var childName: String = ""
}

final class ChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
//    @Published var image: UIImage = UIImage()
//    @Published var grade: Grade = .first
    @Published var grades: [Grade] = Grade.allCases
    @Published var isContentValid: Bool = false
    @Published var isLoading: Bool = false
//    @Published var childName: String = "" {
    @Published var children: [ChildDetailsModel] = [ChildDetailsModel()] {
        didSet {
            isContentValid = !(children.last?.childName.replacingOccurrences(of: " ", with: "").isEmpty ?? true)
        }
    }

    private var addChildUseCase: AddChildUseCase
    
    init(addChildUseCase: AddChildUseCase) {
        self.addChildUseCase = addChildUseCase
    }
    
    func addAnotherChild() {
        guard isContentValid else { return }
        children.append(ChildDetailsModel())
    }
    func appendChildren() {
                guard isContentValid else  { return }
                 isLoading = true
        let validChildren = children.filter{ !$0.childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        var waitingChildCount = validChildren.count
        for child in validChildren {
            let payload = CreateChildPayload(name: child.childName, grade: child.grade, restrictionTime: nil, photo: child.image == UIImage() ? nil : child.image)
                addChildUseCase.execute(payload: payload) { [weak self] result in
                    DispatchQueue.main.async {
                        waitingChildCount -= 1
                        if waitingChildCount == 0 {
                            self?.isLoading = false
                        }
                        }
        //            }
                    switch result {
                    case .none:
                        print("Child added")
                    case .some(let failure):
                        print(failure)
                    }
                }
                        
                    }
    }
}


// MARK: - Preview

final class MockChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    var children: [ChildDetailsModel] = []
    var grades = Grade.allCases
    
    var isContentValid = true
    var isLoading = false
    
    func addAnotherChild() { }
    
    func appendChildren() { }
}
