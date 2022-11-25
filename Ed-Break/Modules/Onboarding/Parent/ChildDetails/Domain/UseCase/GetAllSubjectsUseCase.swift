//
//  GetAllSubjectsUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.11.22.
//

import Foundation

class GetAllSubjectsUseCase: ChildDetailsUseCase {
  
    func execute(completion: @escaping (Result<[SubjectModel], Error>) -> Void) {
        return childDetailsRepository.getSubjects { result in
            switch result {
            case .success(let dto):
                completion(.success(dto.map { SubjectModel(dto: $0) } ))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
  }
}
