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
}

final class DefaultChildrenRepository: MoyaProvider<ChildrenRoute>, ChildrenRepository, ObservableObject {
    
    func getChildren(completion: @escaping (Result<PagingDto<ChildDto>, Error>) -> Void) {
        requestDecodable(.getChildren, completion: completion)
    }
}
