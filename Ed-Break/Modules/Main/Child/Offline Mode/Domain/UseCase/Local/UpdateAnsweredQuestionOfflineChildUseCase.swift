//
//  UpdateAnsweredQuestionOfflineChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 14.09.23.
//

import Combine
import CoreData

class UpdateAnsweredQuestionOfflineChildUseCase: LocalOfflineModeUseCase {
    func execute(
        model: OfflineChildModel,
        in context: NSManagedObjectContext,
        shouldSave: Bool = true
    ) -> AnyPublisher<Bool, Error> {
        offlineChildProvider.update(model: model, shouldSave: shouldSave, in: context)
            .eraseToAnyPublisher()
    }
}
