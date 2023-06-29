//
//  PairChildUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.10.22.
//

import Foundation

class PairChildUseCase: ChildrenUseCase {
    
    func execute(payload: PairChildPayload, completion: @escaping (Error?) -> Void) {
        childrenRepository.pairChild(payload: payload, completion: completion)
    }
    
    func delete(payload: PairChildPayload, completion: @escaping (Error?) -> Void) {
        childrenRepository.removeDevice(payload: payload, completion: completion)
    }

}
