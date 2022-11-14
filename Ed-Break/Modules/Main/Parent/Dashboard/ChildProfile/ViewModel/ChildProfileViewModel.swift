//
//  ChildProfileViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 11.10.22.
//

import UIKit

final class ChildProfileViewModel: ChildProfileViewModeling, Identifiable {
    
    let child: ChildModel
    var datasource: [TimePeriod] = TimePeriod.allCases
    
    @Published var isLoading: Bool = false
    @Published var selectedEducationPeriod: TimePeriod = .day {
        didSet {
            getChildDetails()
        }
    }
    @Published var selectedActivityPeriod: TimePeriod = .day {
        didSet {
            getChildDetails()
        }
    }
    
    @Published var detailsInfo: ChildProfileModel
    
    private var getChildDetailsUseCase: GetChildDetailsUseCase
    private var addRestrictionUseCase: AddRestrictionUseCase
    
    init(child: ChildModel, getChildDetailsUseCase: GetChildDetailsUseCase, addRestrictionUseCase: AddRestrictionUseCase) {
        self.child = child
        self.detailsInfo = ChildProfileModel(childId: child.id)
        self.getChildDetailsUseCase = getChildDetailsUseCase
        self.addRestrictionUseCase = addRestrictionUseCase
        
        getChildDetails()
    }
    
    func getChildDetails() {
        isLoading = true
        let payload = GetChildDetailsPayload(id: child.id, educationPeriod: selectedEducationPeriod, activityPeriod: selectedActivityPeriod)
        getChildDetailsUseCase.execute(payload: payload) { result in
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.detailsInfo = model
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func addRestrictions() {
        let selectionToDiscourage = DataModel.shared.selectionToDiscourage
        guard let data = try? JSONEncoder().encode(selectionToDiscourage),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
              let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .withoutEscapingSlashes),
              let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\"", with: "\\\"")
        else { return }
        addRestrictionUseCase.execute(childId: child.id, restrictions: convertedString) { error in
            print(error?.localizedDescription ?? "")
        }
    }
}


// MARK: - Preview

final class MockChildProfileViewModel: ChildProfileViewModeling, Identifiable {
    var detailsInfo = ChildProfileModel(childId: 0)
    
    var child: ChildModel = ChildModel(dto: ChildDto(id: 0, name: "Emma", grade: 3, restrictionTime: nil, photo: nil, todayAnswers: 20, todayCorrectAnswers: 19, percentageToday: 75, percentageProgress: 95, lastLogin: "Active 14 min ago"))
    var datasource: [TimePeriod] = TimePeriod.allCases
    var isLoading = false
    
    
    var selectedEducationPeriod: TimePeriod = .day
    
    var selectedActivityPeriod: TimePeriod = .month
    
    func getChildDetails() { }
    func addRestrictions() { }
}
