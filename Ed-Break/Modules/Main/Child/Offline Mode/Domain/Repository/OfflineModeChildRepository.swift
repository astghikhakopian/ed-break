//
//  OfflineModeChildRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import Combine
import Moya

protocol OfflineModeChildRepository {
    
    func getChild(completion: @escaping (Result<OfflineChildDto, Error>) -> Void)
}

final class DefaultOfflineModeChildRepository: MoyaProvider<OfflineModeChildRoute>, OfflineModeChildRepository, ObservableObject {
    func getChild(completion: @escaping (Result<OfflineChildDto, Error>) -> Void) {
        requestDecodable(.getChild, completion: completion)
    }
}
