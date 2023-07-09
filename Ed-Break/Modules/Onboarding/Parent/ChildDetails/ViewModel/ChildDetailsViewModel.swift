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
    var grade: Grade = .notSelected
    var interuption: Interuption = .iSelect
    var childName: String = ""
    var subjects: [BottomsheetCellModel]?
    var photoStringUrl: String?
    var isHidden = false
    var devices: [DeviceModel]
    
    init(childId: Int? = nil, image: UIImage = UIImage(), grade: Grade,interuption: Interuption, childName: String, photoStringUrl: String? = nil, subjects: [SubjectModel]?, devices: [DeviceModel] = []) {
        self.id = UUID()
        self.childId = childId
        self.image = image
        self.grade = grade
        self.interuption = interuption
        self.childName = childName
        self.subjects = subjects
        self.photoStringUrl = photoStringUrl
        self.devices = devices
    }
    
    init() {
        self.id = UUID()
        self.childId = nil
        self.image = UIImage()
        self.grade = .notSelected
        self.interuption = .iSelect
        self.childName = ""
        self.subjects = nil
        self.devices = []
    }
}

final class ChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    let child: ChildModel?
    
    @Published var grades: [Grade] = [.first,.second,.third,.fourth, .fifth, .sixth,.seventh,.eightth,.nineth]//Grade.allCases
    @Published var interuptions: [Interuption] = [.i15,.i20,.i25,.i30]//Interuption.allCases
    @Published var subjects: [BottomsheetCellModel] = [SubjectModel(dto: SubjectDto(id: 0, subject: "", photo: "", questionsCount: 0, answeredQuestionsCount: 0, correctAnswersCount: 0, completed: false))]
    @Published var isContentValid: Bool = false
    @Published var isLoading: Bool = false
    @Published var children: [ChildDetailsModel] = [ChildDetailsModel()] {
        didSet {
            let lastNoneHiddenChild = children.last(where: { !$0.isHidden })
            isContentValid = !(lastNoneHiddenChild?.childName.replacingOccurrences(of: " ", with: "").isEmpty ?? true) && lastNoneHiddenChild?.grade != .notSelected && lastNoneHiddenChild?.subjects != nil && lastNoneHiddenChild?.interuption != .iSelect
        }
    }
    
    private var addChildUseCase: AddChildUseCase?
    private var updateChildUseCase: UpdateChildUseCase?
    private var deleteChildUseCase: DeleteChildUseCase?
    private var getAllSubjectsUseCase: GetAllSubjectsUseCase
    private let pairChildUseCase: PairChildUseCase
    
    init(child: ChildModel? = nil, addChildUseCase: AddChildUseCase? = nil, updateChildUseCase: UpdateChildUseCase? = nil, deleteChildUseCase: DeleteChildUseCase? = nil, getAllSubjectsUseCase: GetAllSubjectsUseCase, pairChildUseCase: PairChildUseCase) {
        self.child = child
        self.addChildUseCase = addChildUseCase
        self.updateChildUseCase = updateChildUseCase
        self.deleteChildUseCase = deleteChildUseCase
        self.getAllSubjectsUseCase = getAllSubjectsUseCase
        self.pairChildUseCase = pairChildUseCase
        
        if let child = child {
            children = [
                ChildDetailsModel(
                    childId: child.id,
                    grade: child.grade,
                    interuption: Interuption(rawValue: child.interruption ?? 0) ?? .iSelect,
                    childName: child.name,
                    photoStringUrl: child.photoUrl?.absoluteString,
                    subjects: child.subjects,
                    devices: child.devices
                )
            ]
        }
        
        getSubjects()
    }
    
    func addAnotherChild() {
        guard isContentValid else { return }
        children.append(ChildDetailsModel())
    }
    func removeChild(child: ChildDetailsModel) {
        children = children.map { if $0.id == child.id { $0.isHidden = true };  return $0 }//.removeAll(where: { child.id == $0.id })
    }
    
    func appendChildren() {
        guard let addChildUseCase = addChildUseCase else { return }
        guard isContentValid else  { return }
        isLoading = true
        let validChildren = children.filter{ !$0.childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !$0.isHidden }
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
    
    func pairChild(id: Int, deviceToken: String, name: String, model: String, compleated: @escaping (Bool)->()) {
        isLoading = true
        pairChildUseCase.execute(
            payload: PairChildPayload(
                id: id,
                deviceToken: deviceToken,
                childDeviceName: name,
                childDeviceModel: model
            )
        ) { error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                compleated(false)
                print(error.localizedDescription)
                return
            }
            compleated(true)
        }
    }
    
    func removeDevice(device: DeviceModel, compleated: @escaping (Bool)->()) {
        isLoading = true
        pairChildUseCase.delete(payload: PairChildPayload(
            id: device.id,
            deviceToken: device.deviceToken,
            childDeviceName: device.deviceName,
            childDeviceModel: device.deviceType.modelName
        ), completion: { error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                compleated(false)
                print(error.localizedDescription)
                return
            }
            compleated(true)
        })
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
    func pairChild(id: Int, deviceToken: String, name: String, model: String, compleated: @escaping (Bool)->()) { }
    func removeDevice(device: DeviceModel, compleated: @escaping (Bool)->()) { }
}
