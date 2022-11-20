//
//  QuestionsUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 15.11.22.
//

class QuestionsUseCase {
    
    let questionsRepository: QuestionsRepository
    
    init(questionsRepository: QuestionsRepository) {
        self.questionsRepository = questionsRepository
    }
}
