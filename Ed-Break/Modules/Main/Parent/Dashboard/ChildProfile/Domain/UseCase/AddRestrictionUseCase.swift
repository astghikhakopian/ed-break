//
//  AddRestrictionUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.11.22.
//

import Foundation

class AddRestrictionUseCase: RestrictionsUseCase {
    
    func execute(childId: Int, restrictions: String, completion: @escaping(Error?) -> Void) {
        restrictionsRepository.addRestriction(childId: childId, restrictions: restrictions, completion: completion)
    }
}
