//
//  FamilySharingRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Combine
import Moya

protocol FamilySharingRepository {
    func addParent(username: String, completion:  @escaping(Result<TokenDto, Error>) -> Void)
}

final class DefaultFamilySharingRepository: MoyaProvider<FamilySharingRequestManagerRoute>, FamilySharingRepository, ObservableObject {
    
    func addParent(username: String, completion:  @escaping(Result<TokenDto, Error>) -> Void) {
        requestDecodable(.addParent(username: username), completion: completion)
    }
}
