//
//  ChildrenViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import UIKit

final class ChildrenViewModel: ChildrenViewModeling, Identifiable {
    @Published var children = PagingModel<ChildModel>(results: [])
    @Published var coachingChildren = [CoachingChildModel]()
    @Published var isLoading: Bool = false
    @Published var isContentValid: Bool = false
    @Published var connectedChildren = [ChildModel]() {
        didSet {
            isContentValid = connectedChildren.count == children.count
        }
    }
    @Published var selectedPeriod: TimePeriod = .week  {
        didSet {
            getCoachingChildren()
        }
    }
    var timePeriodDatasource: [TimePeriod] = TimePeriod.allCases
    
    private var getChildrenUseCase: GetChildrenUseCase
    private var pairChildUseCase: PairChildUseCase
    private var getCoachingUseCase: GetCoachingUseCase?
    
    init(getChildrenUseCase: GetChildrenUseCase, pairChildUseCase: PairChildUseCase, getCoachingUseCase: GetCoachingUseCase? = nil) {
        self.getChildrenUseCase = getChildrenUseCase
        self.pairChildUseCase = pairChildUseCase
        self.getCoachingUseCase = getCoachingUseCase
        
        getChildren()
        getCoachingChildren()
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
    
    func getCoachingChildren() {
        guard let getCoachingUseCase = getCoachingUseCase else { return }
        isLoading = true
        getCoachingUseCase.execute(timePeriod: selectedPeriod) { result in
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let models):
                DispatchQueue.main.async { [weak self] in
                    self?.coachingChildren = models
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func pairChild(id: Int, deviceToken: String, compleated: @escaping (Bool)->()) {
        isLoading = true
        pairChildUseCase.execute(payload: PairChildPayload(id: id, deviceToken: deviceToken)) { error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                compleated(false)
                print(error.localizedDescription)
                return
            }
            compleated(true)
        }
    }
}


// MARK: - Preview

final class MockChildrenViewModeling: ChildrenViewModeling, Identifiable {
    
    var isLoading = false
    var isContentValid = false
    var connectedChildren = [ChildModel]()
    var selectedPeriod: TimePeriod = .day
    var timePeriodDatasource: [TimePeriod] = TimePeriod.allCases
    var children = PagingModel<ChildModel>(results: [ChildModel(dto: ChildDto(id: 0, name: "Emma", grade: 3, restrictionTime: nil, photo: nil, todayAnswers: 20, todayCorrectAnswers: 19, percentageToday: 85, percentageProgress: 95, lastLogin: "Active 14 min ago"))])
    var coachingChildren = [CoachingChildModel]()
    
    func getChildren() { }
    func pairChild(id: Int, deviceToken: String, compleated: @escaping (Bool)->()) { }
}
