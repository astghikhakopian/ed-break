//
//  ResultOfAdditionalQuestionsUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.12.22.
//

import Foundation

class ResultOfAdditionalQuestionsUseCase: QuestionsUseCase {
    
    func execute(completion: @escaping (Error?) -> Void) {
        questionsRepository.resultOfAdditionalQuestions(completion: completion)
    }
}
