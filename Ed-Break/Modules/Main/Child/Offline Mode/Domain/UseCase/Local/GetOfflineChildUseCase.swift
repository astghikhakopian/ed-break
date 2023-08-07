//
//  GetOfflineChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 05.08.23.
//

import Combine
import CoreData

class GetOfflineChildUseCase: LocalOfflineModeUseCase {
    func execute(
        in context: NSManagedObjectContext
    ) -> AnyPublisher<OfflineChildMO, Error> {
        offlineChildProvider.fetch(in: context)
            .eraseToAnyPublisher()
    }
}
