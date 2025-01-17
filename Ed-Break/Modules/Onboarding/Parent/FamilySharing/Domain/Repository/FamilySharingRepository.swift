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
    func askToJoin(currentDeviceToken: String, familyOwnerDeviceToken: String, completion:  @escaping(Result<TokenDto, Error>) -> Void)
    func refreshToken(completion:  @escaping(Result<TokenDto, Error>) -> Void)
}

final class DefaultFamilySharingRepository: MoyaProvider<FamilySharingRoute>, FamilySharingRepository, ObservableObject {
    
    func addParent(username: String, completion:  @escaping(Result<TokenDto, Error>) -> Void) {
        requestDecodable(.addParent(username: username), completion: completion)
    }
    func askToJoin(currentDeviceToken: String, familyOwnerDeviceToken: String, completion:  @escaping(Result<TokenDto, Error>) -> Void) {
        requestDecodable(.joinToFamily(currentDeviceToken: currentDeviceToken, familyOwnerDeviceToken: familyOwnerDeviceToken), completion: completion)
    }
    func refreshToken(completion:  @escaping(Result<TokenDto, Error>) -> Void) {
        requestDecodable(.refreshToken, completion: completion)
    }
}
