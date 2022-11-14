//
//  RestrictionsRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.11.22.
//

import Combine
import Moya
import Foundation

protocol RestrictionsRepository {
    
    func addRestriction(childId: Int, restrictions: String, completion: @escaping(Error?) -> Void)
}

final class DefaultRestrictionsRepository: MoyaProvider<RestrictionsRoute>, RestrictionsRepository, ObservableObject {
    
    func addRestriction(childId: Int, restrictions: String, completion: @escaping(Error?) -> Void) {
        requestSimple(.addRestriction(childId: childId, restrictions: restrictions), completion: completion)
    }
}
