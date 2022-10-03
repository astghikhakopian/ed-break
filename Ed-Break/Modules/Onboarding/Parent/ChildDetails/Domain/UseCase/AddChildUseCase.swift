//
//  AddChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import Foundation

class AddChildUseCase: ChildDetailsUseCase {
  
    func execute(payload: CreateChildPayload, completion: @escaping (Error?) -> Void) {
        return childDetailsRepository.addChild(payload: payload, completion: completion)
  }
}
