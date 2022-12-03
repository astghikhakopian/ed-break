//
//  ChildDetailsViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

class ChildDetailsModel {
    var id: UUID = UUID()
    var childId: Int? = nil
    @Published var image = UIImage()
    var grade: Grade = .first
    var interuption: Interuption = .i15
    var childName: String = ""
    var subjects: [BottomsheetCellModel]?
    var photoStringUrl: String?
    
    init(childId: Int? = nil, image: UIImage = UIImage(), grade: Grade, childName: String, photoStringUrl: String? = nil, subjects: [SubjectModel]?) {
        self.id = UUID()
        self.childId = childId
        self.image = image
        self.grade = grade
        self.childName = childName
        self.subjects = subjects
        self.photoStringUrl = photoStringUrl
    }
    
    init() {
        self.id = UUID()
        self.childId = nil
        self.image = UIImage()
        self.grade = .first
        self.childName = ""
        self.subjects = nil
    }
}

final class ChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    let child: ChildModel?
    
    @Published var grades: [Grade] = Grade.allCases
    @Published var interuptions: [Interuption] = Interuption.allCases
    @Published var subjects: [BottomsheetCellModel] = [SubjectModel(dto: SubjectDto(id: 0, subject: "", photo: "", questionsCount: 0, completedCount: 0, correctAnswersCount: 0, completed: false))]
    @Published var isContentValid: Bool = false
    @Published var isLoading: Bool = false
    @Published var children: [ChildDetailsModel] = [ChildDetailsModel()] {
        didSet {
            isContentValid = !(children.last?.childName.replacingOccurrences(of: " ", with: "").isEmpty ?? true)
        }
    }
    
    private var addChildUseCase: AddChildUseCase?
    private var updateChildUseCase: UpdateChildUseCase?
    private var deleteChildUseCase: DeleteChildUseCase?
    private var getAllSubjectsUseCase: GetAllSubjectsUseCase
    
    init(child: ChildModel? = nil, addChildUseCase: AddChildUseCase? = nil, updateChildUseCase: UpdateChildUseCase? = nil, deleteChildUseCase: DeleteChildUseCase? = nil, getAllSubjectsUseCase: GetAllSubjectsUseCase) {
        self.child = child
        self.addChildUseCase = addChildUseCase
        self.updateChildUseCase = updateChildUseCase
        self.deleteChildUseCase = deleteChildUseCase
        self.getAllSubjectsUseCase = getAllSubjectsUseCase
        
        if let child = child {
            children = [ChildDetailsModel(childId: child.id, grade: child.grade, childName: child.name, photoStringUrl: child.photoUrl?.absoluteString, subjects: child.subjects)]
        }
        
        getSubjects()
    }
    
    func addAnotherChild() {
        guard isContentValid else { return }
        children.append(ChildDetailsModel())
    }
    func removeChild(child: ChildDetailsModel) {
        children.removeAll(where: { child.id == $0.id })
    }
    
    func appendChildren() {
        guard let addChildUseCase = addChildUseCase else { return }
        guard isContentValid else  { return }
        isLoading = true
        let validChildren = children.filter{ !$0.childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        var waitingChildCount = validChildren.count
        for child in validChildren {
            let payload = CreateChildPayload(name: child.childName, grade: child.grade, restrictionTime: nil, interruption: child.interuption.rawValue, subjects: child.subjects?.map{ $0.id }, photo: child.image == UIImage() ? nil : child.image)
            addChildUseCase.execute(payload: payload) { [weak self] result in
                DispatchQueue.main.async {
                    waitingChildCount -= 1
                    if waitingChildCount == 0 {
                        self?.isLoading = false
                    }
                }
                switch result {
                case .none:
                    print("Child added")
                case .some(let failure):
                    print(failure)
                }
            }
        }
    }
    
    func updateChild(completion: (()->())? = nil) {
        guard let updateChildUseCase = updateChildUseCase, let child = children.first, let childId = child.childId else { return }
        guard isContentValid else  { return }
        isLoading = true
        let payload = CreateChildPayload(name: child.childName, grade: child.grade, restrictionTime: nil, interruption: child.interuption.rawValue, subjects: child.subjects?.map{ $0.id }, photo: child.image == UIImage() ? nil : child.image)
        updateChildUseCase.execute(id: childId, payload: payload) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            switch result {
            case .none:
                print("Child updated")
                completion?()
            case .some(let failure):
                print(failure)
            }
        }
    }
    func deleteChild(completion: (()->())? = nil) {
        guard let deleteChildUseCase = deleteChildUseCase, let child = children.first, let childId = child.childId else { return }
        guard isContentValid else  { return }
        isLoading = true
        deleteChildUseCase.execute(id: childId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            switch result {
            case .none:
                print("Child updated")
                completion?()
            case .some(let failure):
                print(failure)
            }
        }
    }
    func getSubjects() {
        getAllSubjectsUseCase.execute { [weak self] result in
            switch result {
            case .success(let subjects):
                DispatchQueue.main.async {
                    self?.subjects = subjects
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


// MARK: - Preview

final class MockChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    var children: [ChildDetailsModel] = [ChildDetailsModel()]
    var interuptions: [Interuption] = Interuption.allCases
    var grades = Grade.allCases
    var subjects: [BottomsheetCellModel] = []
    
    var isContentValid = true
    var isLoading = false
    
    func addAnotherChild() { }
    func updateChild(completion: (()->())?) {}
    func deleteChild(completion: (()->())?) {}
    func removeChild(child: ChildDetailsModel) { }
    
    func appendChildren() { }
    func getSubjects() { }
}
