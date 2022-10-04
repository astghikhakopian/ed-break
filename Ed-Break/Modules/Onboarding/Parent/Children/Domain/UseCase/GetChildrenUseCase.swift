//
//  GetChildrenUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import Foundation

class GetChildrenUseCase: ChildrenUseCase {
    
    func execute(completion: @escaping (Result<[ChildModel], Error>) -> Void) {
        childrenRepository.getChildren { result in
            switch result {
            case .success(let dto):
                completion(.success(dto.results.map { ChildModel(dto: $0) } ))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
