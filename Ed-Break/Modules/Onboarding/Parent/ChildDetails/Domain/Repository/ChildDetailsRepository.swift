//
//  ChildDetailsRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import Combine
import Moya

protocol ChildDetailsRepository {
    
    func addChild(payload: CreateChildPayload, completion: @escaping(Error?) -> Void)
    func updateChild(id: Int, payload: CreateChildPayload, completion: @escaping(Error?) -> Void)
    func deleteChild(id: Int, completion: @escaping(Error?) -> Void)
    func getSubjects(completion: @escaping (Result<[SubjectDto], Error>) -> Void)
}

final class DefaultChildDetailsRepository: MoyaProvider<ChildDetailsRoute>, ChildDetailsRepository, ObservableObject {
    
    func addChild(payload: CreateChildPayload, completion: @escaping(Error?) -> Void) {
        requestSimple(.addChild(payload: payload), completion: completion)
    }
    func updateChild(id: Int, payload: CreateChildPayload, completion: @escaping(Error?) -> Void) {
        requestSimple(.updateChild(id: id, payload: payload), completion: completion)
    }
    func deleteChild(id: Int, completion: @escaping(Error?) -> Void) {
        requestSimple(.deleteChild(id: id), completion: completion)
    }
    func getSubjects(completion: @escaping (Result<[SubjectDto], Error>) -> Void) {
        requestDecodable(.getSubjects, completion: completion)
    }
}
