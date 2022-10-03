//
//  ChildDetailsViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

final class ChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    @Published var image: UIImage = UIImage()
    @Published var childName: String = ""
    @Published var grade: Grade = .first
    @Published var grades: [Grade] = Grade.allCases
    
    private var addChildUseCase: AddChildUseCase
    
    init(addChildUseCase: AddChildUseCase) {
        self.addChildUseCase = addChildUseCase
    }
    
    func addChild() {
        guard !childName.replacingOccurrences(of: " ", with: "").isEmpty else  { return }
        let payload = CreateChildPayload(name: childName, grade: grade, restrictionTime: nil, photo: image == UIImage() ? nil : image)
        addChildUseCase.execute(payload: payload) { result in
            switch result {
            case .none:
                print("Child added")
            case .some(let failure):
                print(failure)
            }
        }
    }
    
    func prepareForNewChild() {
        image = UIImage()
        childName = ""
        grade = .first
    }
}


// MARK: - Preview

final class MockChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    var image = UIImage()
    var childName = ""
    var grade = Grade.first
    var grades = Grade.allCases
    
    func addChild() { }
    func prepareForNewChild() { }
}
