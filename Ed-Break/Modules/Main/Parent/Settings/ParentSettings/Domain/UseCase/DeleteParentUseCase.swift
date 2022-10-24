//
//  DeleteParentUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import Foundation

class DeleteParentUseCase: ParentUseCase {
    
    func execute(completion: @escaping (Error?) -> Void) {
        return parentRepository.deleteParent(completion: completion)
    }
}
