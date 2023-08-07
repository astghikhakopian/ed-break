//
//  LocalOfflineModeUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 05.08.23.
//

class LocalOfflineModeUseCase {
    
    var offlineChildProvider: OfflineChildProvideerProtocol
    
    init(offlineChildProvider: OfflineChildProvideerProtocol) {
        self.offlineChildProvider = offlineChildProvider
    }
}
