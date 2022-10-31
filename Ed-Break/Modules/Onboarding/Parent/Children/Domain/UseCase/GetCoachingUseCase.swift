//
//  GetCoachingUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import Foundation

class GetCoachingUseCase: ChildrenUseCase {
    
    func execute(timePeriod: TimePeriod, completion: @escaping (Result<[ChildModel], Error>) -> Void) {
//        childrenRepository.getCoachingChildren(timePeriod: timePeriod) { result in
//            switch result {
//            case .success(let dto):
//                completion(.success(dto.results.map { ChildModel(dto: $0) } ))
//            case .failure(let failure):
//                completion(.failure(failure))
//            }
            completion(.success([ChildModel(dto:  ChildDto(id: 0, name: "Emma", grade: 3, restrictionTime: nil, photo: nil, todayAnswers: 20, todayCorrectAnswers: 19, percentageToday: 95, lastLogin: "Active 14 min ago"))] ))
//        }
    }
}
