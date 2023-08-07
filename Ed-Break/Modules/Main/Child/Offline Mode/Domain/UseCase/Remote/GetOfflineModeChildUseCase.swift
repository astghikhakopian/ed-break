//
//  GetOfflineModeChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import Foundation

class GetOfflineModeChildUseCase: OfflineModeUseCase {
    
    func execute(completion: @escaping (Result<OfflineChildModel, Error>) -> Void) {
        offlineModeChildRepository.getChild { result in
            switch result {
            case .success(let dto):
                completion(.success(OfflineChildModel(dto: dto)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

