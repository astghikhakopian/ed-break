//
//  ChildrenRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import Combine
import Moya

protocol ChildrenRepository {
    
    func getChildren(completion: @escaping (Result<PagingDto<ChildDto>, Error>) -> Void)
    func getChildDetails(payload: GetChildDetailsPayload, completion: @escaping (Result<ChildRetriveDto, Error>) -> Void)
    func pairChild(payload: PairChildPayload, completion: @escaping(Error?) -> Void)
    func checkConnection(payload: PairChildPayload, completion: @escaping(Error?) -> Void)
}

final class DefaultChildrenRepository: MoyaProvider<ChildrenRoute>, ChildrenRepository, ObservableObject {
    
    func getChildren(completion: @escaping (Result<PagingDto<ChildDto>, Error>) -> Void) {
        requestDecodable(.getChildren, completion: completion)
    }
    func getChildDetails(payload: GetChildDetailsPayload, completion:  @escaping (Result<ChildRetriveDto, Error>) -> Void) {
        requestDecodable(.getChildDetails(payload: payload), completion: completion)
    }
    func pairChild(payload: PairChildPayload, completion: @escaping(Error?) -> Void) {
        requestSimple(.pairChild(payload: payload), completion: completion)
    }
    func checkConnection(payload: PairChildPayload, completion: @escaping(Error?) -> Void) {
        requestSimple(.checkConnection(payload: payload), completion: completion)
    }
}
