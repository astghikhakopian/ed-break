//
//  UpdateOfflineChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 05.08.23.
//

import Combine
import CoreData

class UpdateOfflineChildUseCase: LocalOfflineModeUseCase {
    func execute(
        childMO: OfflineChildMO,
        by child: OfflineChildModel,
        in context: NSManagedObjectContext,
        shouldSave: Bool = true
    ) -> AnyPublisher<Bool, Error> {
        offlineChildProvider.update(childMO: childMO, by: child, shouldSave: shouldSave)
            .eraseToAnyPublisher()
    }
}
