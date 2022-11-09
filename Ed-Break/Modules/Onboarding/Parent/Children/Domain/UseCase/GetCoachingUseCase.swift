//
//  GetCoachingUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import Foundation

class GetCoachingUseCase: ChildrenUseCase {
    
    func execute(timePeriod: TimePeriod, completion: @escaping (Result<[ChildModel], Error>) -> Void) {
        childrenRepository.getCoachingChildren(timePeriod: timePeriod) { result in
            switch result {
            case .success(let dto):
                completion(.success(dto.results.map { ChildModel(dto: $0) } ))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
