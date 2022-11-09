//
//  CheckConnectionUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.10.22.
//

import Foundation

class CheckConnectionUseCase: ChildrenUseCase {
    
    func execute(payload: PairChildPayload, completion: @escaping (Result<TokenDto, Error>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//            completion(.success( TokenDto(refresh: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY3MDIzNjMzNCwiaWF0IjoxNjY3NjQ0MzM0LCJqdGkiOiI3Y2NkZDUxZjllYWU0MmUwODcwZGNiM2NlNzhiNzE5OSIsInVzZXJfaWQiOjE2M30.8NQJc_0lyXfbcPHjm1THfawpOqjsARUapwFYK_wAur0", access: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjY3NzMwNzM0LCJpYXQiOjE2Njc2NDQzMzQsImp0aSI6IjBmMDBjMTIxOWJjMDRlZjliYmU0ZTFiMDM4ZWY5MjY4IiwidXNlcl9pZCI6MTYzfQ.JBN-m2_b0UW4OHB1ZOBd30poEzSuk9gZ7L2qWlX_K9I")))
//        })
        
          childrenRepository.checkConnection(payload: payload, completion: completion)
    }
}
