//
//  UpdateChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 25.10.22.
//

import Foundation

class UpdateChildUseCase: ChildDetailsUseCase {
  
    func execute(id: Int, payload: CreateChildPayload, completion: @escaping (Error?) -> Void) {
        return childDetailsRepository.updateChild(id: id, payload: payload, completion: completion)
  }
}
