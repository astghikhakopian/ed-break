//
//  AddInterruptionUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.11.22.
//

import Foundation

class AddInterruptionUseCase: RestrictionsUseCase {
    
    func execute(childId: Int, interruption: Int, completion: @escaping(Error?) -> Void) {
        restrictionsRepository.addInterruption(childId: childId, interruption: interruption, completion: completion)
    }
}
