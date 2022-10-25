//
//  DeleteChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 25.10.22.
//

import Foundation

class DeleteChildUseCase: ChildDetailsUseCase {
  
    func execute(id: Int, completion: @escaping (Error?) -> Void) {
        return childDetailsRepository.deleteChild(id: id, completion: completion)
  }
}
