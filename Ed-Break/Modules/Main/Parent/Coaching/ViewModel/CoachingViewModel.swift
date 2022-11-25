//
//  CoachingViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 31.10.22.
//

import UIKit

final class CoachingViewModel: CoachingViewModeling, Identifiable {
    @Published var children = PagingModel<CoachingChildModel>(results: [])
    @Published var isLoading: Bool = false
    @Published var selectedPeriod: TimePeriod = .day  {
        didSet {
            getCoachingChildren()
        }
    }
    var timePeriodDatasource: [TimePeriod] = TimePeriod.allCases
    
    private var getCoachingUseCase: GetCoachingUseCase
    
    init(getCoachingUseCase: GetCoachingUseCase) {
        self.getCoachingUseCase = getCoachingUseCase
    }

    
    func getCoachingChildren() {
        isLoading = true
        getCoachingUseCase.execute(timePeriod: selectedPeriod) { result in
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

final class MockCoachingViewModel: CoachingViewModeling, Identifiable {
    
    var isLoading = false
    var connectedChildren = [CoachingChildModel]()
    var selectedPeriod: TimePeriod = .day
    var timePeriodDatasource: [TimePeriod] = TimePeriod.allCases
    var children = PagingModel<CoachingChildModel>(results: [])
    
    func getCoachingChildren() { }
}
