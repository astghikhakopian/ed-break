//
//  ParentUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

class ParentUseCase {
    
    let parentRepository: ParentRepository
    
    init(parentRepository: ParentRepository) {
        self.parentRepository = parentRepository
    }
}
