//
//  AddOfflineChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 05.08.23.
//

import Combine
import CoreData

class AddOfflineChildUseCase: LocalOfflineModeUseCase {
    func execute(
        childModel: OfflineChildModel,
        in context: NSManagedObjectContext,
        shouldSave: Bool = true
    ) -> AnyPublisher<Bool, Error> {
        offlineChildProvider.addChild(childModel, in: context, shouldSave: shouldSave)
            .eraseToAnyPublisher()
    }
}
