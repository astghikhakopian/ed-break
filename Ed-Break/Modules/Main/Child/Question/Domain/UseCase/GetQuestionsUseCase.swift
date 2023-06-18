//
//  GetQuestionsUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 15.11.22.
//

import Foundation

class GetQuestionsUseCase: QuestionsUseCase {
    
    func execute(subjectId: Int, completion: @escaping (Result<QuestionsContainerModel, Error>) -> Void) {
        questionsRepository.getQuestions(subjectId: subjectId) { result in
            switch result {
            case .success(let dto):
                completion(.success(QuestionsContainerModel(dto: dto)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
