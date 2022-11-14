//
//  RestrictionsUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.11.22.
//

class RestrictionsUseCase {
    
    let restrictionsRepository: RestrictionsRepository
    
    init(restrictionsRepository: RestrictionsRepository) {
        self.restrictionsRepository = restrictionsRepository
    }
}
