//
//  RefreshTokenUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 21.11.22.
//

import Foundation

class RefreshTokenUseCase: FamilySharingUseCase {
    
    func execute(completion: @escaping (Result<TokenModel, Error>) -> Void) {
        return familySharingRepository.refreshToken { result in
            switch result {
            case .success(let dto):
                completion(.success(TokenModel(refresh: dto.refresh, access: dto.access)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
