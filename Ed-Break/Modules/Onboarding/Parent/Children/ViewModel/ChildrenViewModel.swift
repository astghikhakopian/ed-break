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
            isContentValid = !connectedChildren.isEmpty//.count == children.count
        }
    }
    @Published var selectedPeriod: TimePeriod = .week  {
        didSet {
            getCoachingChildren()
        }
    }
    var timePeriodDatasource: [TimePeriod] = TimePeriod.allCases
    var updatedRefreshToken = false
    
    private var getChildrenUseCase: GetChildrenUseCase
    private var pairChildUseCase: PairChildUseCase
    private var getCoachingUseCase: GetCoachingUseCase?
    private let refreshTokenUseCase: RefreshTokenUseCase
    
    init(getChildrenUseCase: GetChildrenUseCase, pairChildUseCase: PairChildUseCase, getCoachingUseCase: GetCoachingUseCase? = nil, refreshTokenUseCase: RefreshTokenUseCase) {
        self.getChildrenUseCase = getChildrenUseCase
        self.pairChildUseCase = pairChildUseCase
        self.getCoachingUseCase = getCoachingUseCase
        self.refreshTokenUseCase = refreshTokenUseCase
        
        getChildren()
        getCoachingChildren()
    }
    
    func getChildren() {
        DispatchQueue.main.async { self.isLoading = true }
        getChildrenUseCase.execute { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let models):
                DispatchQueue.main.async { [weak self] in
                    self?.children = PagingModel(results: models)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                guard !self.updatedRefreshToken else { return }
                self.updatedRefreshToken = true
                self.refreshToken { [weak self] success in
                    guard success else { return }
                    self?.getChildren()
                }
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
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        let localStorageService = UserDefaultsService()
        refreshTokenUseCase.execute { result in
            switch result {
            case .success(let token):
                localStorageService.setObject(token, forKey: .User.token)
                localStorageService.setPrimitive(true, forKey: .User.isLoggedIn)
                completion(true)
            case .failure(let failure):
                print(failure)
                completion(false)
            }
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
    var children = PagingModel<ChildModel>(results: [ChildModel(dto: ChildDto(id: 0, name: "Emma", grade: 1, restrictionTime: nil, photo: nil, todayAnswers: nil, todayCorrectAnswers: nil, percentageToday: nil, percentageProgress: nil, lastLogin: nil, breakEndDatetime: nil, breakStartDatetime: nil, wrongAnswersTime: nil, deviceToken: nil, restrictions: nil, subjects: []))])
    var coachingChildren = [CoachingChildModel]()
    
    func getChildren() { }
    func pairChild(id: Int, deviceToken: String, compleated: @escaping (Bool)->()) { }
    func refreshToken(completion: @escaping (Bool) -> Void) { }
}
