//
//  GetChildDetailsUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 13.10.22.
//

import Foundation

class GetChildDetailsUseCase: ChildrenUseCase {
    
    func execute(payload: GetChildDetailsPayload, completion: @escaping (Result<ChildProfileModel, Error>) -> Void) {
        childrenRepository.getChildDetails(payload: payload) { result in
            switch result {
            case .success(let dto):
                completion(.success(ChildProfileModel(dto: dto)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
