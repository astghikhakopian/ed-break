//
//  OfflineModeUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

class OfflineModeUseCase {
    
    let offlineModeChildRepository: OfflineModeChildRepository
    
    init(offlineModeChildRepository: OfflineModeChildRepository) {
        self.offlineModeChildRepository = offlineModeChildRepository
    }
}
