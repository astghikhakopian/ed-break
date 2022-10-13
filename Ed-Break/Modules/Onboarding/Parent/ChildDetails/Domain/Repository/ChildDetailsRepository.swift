//
//  ChildDetailsRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import Combine
import Moya

protocol ChildDetailsRepository {
    
    func addChild(payload: CreateChildPayload, completion: @escaping(Error?) -> Void)
}

final class DefaultChildDetailsRepository: MoyaProvider<ChildDetailsRoute>, ChildDetailsRepository, ObservableObject {
    
    func addChild(payload: CreateChildPayload, completion: @escaping(Error?) -> Void) {
        requestSimple(.addChild(payload: payload), completion: completion)
    }
}
