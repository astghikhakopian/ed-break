//
//  ParentRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import Combine
import Moya

protocol ParentRepository {
    func deleteParent(completion: @escaping(Error?) -> Void)
}

final class DefaultParentRepository: MoyaProvider<ParentRoute>, ParentRepository, ObservableObject {
    
    func deleteParent(completion: @escaping(Error?) -> Void) {
        requestSimple(.deleteParent, completion: completion)
    }
}
