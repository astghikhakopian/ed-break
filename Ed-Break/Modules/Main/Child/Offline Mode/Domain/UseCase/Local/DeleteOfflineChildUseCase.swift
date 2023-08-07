//
//  DeleteOfflineChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 05.08.23.
//

import Combine
import CoreData

class DeleteOfflineChildUseCase: LocalOfflineModeUseCase {
    func execute(
        childMO: OfflineChildMO,
        shouldSave: Bool = true
    ) -> AnyPublisher<Bool, Error> {
        offlineChildProvider.delete(child: childMO, shouldSave: shouldSave)
            .eraseToAnyPublisher()
    }
}
