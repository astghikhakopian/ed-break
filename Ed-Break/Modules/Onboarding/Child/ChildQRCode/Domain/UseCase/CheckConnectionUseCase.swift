//
//  CheckConnectionUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.10.22.
//

import Foundation

class CheckConnectionUseCase: ChildrenUseCase {
    
    func execute(payload: PairChildPayload, completion: @escaping (Result<TokenDto, Error>) -> Void) {
        childrenRepository.checkConnection(payload: payload, completion: completion)
    }
}
