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
    
    init(child: ChildModel, getChildDetailsUseCase: GetChildDetailsUseCase) {
        self.child = child
        self.detailsInfo = ChildProfileModel(childId: child.id)
        self.getChildDetailsUseCase = getChildDetailsUseCase
        
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
}


// MARK: - Preview

final class MockChildProfileViewModel: ChildProfileViewModeling, Identifiable {
    var detailsInfo = ChildProfileModel(childId: 0)
    
    var child: ChildModel = ChildModel(dto: ChildDto(id: 0, name: "Emma", grade: 3, restrictionTime: nil, photo: nil, todayAnswers: 20, todayCorrectAnswers: 19, percentageToday: 95, lastLogin: "Active 14 min ago"))
    var datasource: [TimePeriod] = TimePeriod.allCases
    var isLoading = false
    
    
    var selectedEducationPeriod: TimePeriod = .day
    
    var selectedActivityPeriod: TimePeriod = .month
    
    func getChildDetails() { }
}
