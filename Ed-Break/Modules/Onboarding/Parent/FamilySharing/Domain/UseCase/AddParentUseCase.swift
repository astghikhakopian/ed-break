//
//  AddParentUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation

class AddParentUseCase: FamilySharingUseCase {
    
    func execute(username: String, completion: @escaping (Result<TokenModel, Error>) -> Void) {
        return familySharingRepository.addParent(username: username) { result in
            switch result {
            case .success(let dto):
                completion(.success(TokenModel(refresh: dto.refresh, access: dto.access)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func askToJoin(currentDeviceToken: String, familyOwnerDeviceToken: String, completion: @escaping (Result<TokenModel, Error>) -> Void) {
        return familySharingRepository.askToJoin(currentDeviceToken: currentDeviceToken, familyOwnerDeviceToken: familyOwnerDeviceToken) { result in
            switch result {
            case .success(let dto):
                completion(.success(TokenModel(refresh: dto.refresh, access: dto.access)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
