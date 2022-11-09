//
//  GetSubjectsUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//

import Foundation

class GetSubjectsUseCase: ChildrenUseCase {
    
    func execute(completion: @escaping (Result<HomeModel, Error>) -> Void) {
        childrenRepository.getSubjects { result in
            switch result {
            case .success(let dto):
                completion(.success(HomeModel(dto: dto)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
