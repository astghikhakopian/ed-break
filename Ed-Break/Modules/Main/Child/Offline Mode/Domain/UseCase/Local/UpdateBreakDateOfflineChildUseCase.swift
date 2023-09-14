//
//  UpdateBreakDateOfflineChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 16.08.23.
//

import Combine
import CoreData

class UpdateBreakDateOfflineChildUseCase: LocalOfflineModeUseCase {
    func execute(
        date: Date?,
        in context: NSManagedObjectContext,
        shouldSave: Bool = true
    ) -> AnyPublisher<Bool, Error> {
        offlineChildProvider.update(date: date, shouldSave: shouldSave, in: context)
            .eraseToAnyPublisher()
    }
}
