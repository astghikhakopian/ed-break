//
//  GetCoachingUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import Foundation

class GetCoachingUseCase: ChildrenUseCase {
    
    func execute(timePeriod: TimePeriod, completion: @escaping (Result<[CoachingChildModel], Error>) -> Void) {
        childrenRepository.getCoachingChildren(timePeriod: timePeriod) { result in
            switch result {
            case .success(let dto):
                completion(.success(dto.data.map { CoachingChildModel(dto: $0) } ))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
