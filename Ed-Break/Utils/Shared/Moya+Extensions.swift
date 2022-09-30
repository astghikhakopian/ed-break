//
//  Moya+Extensions.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation
import Moya

extension MoyaProvider {
    @discardableResult func requestSimple(_ target: Target, completion: @escaping (Error?) -> Void) -> Cancellable {
        request(target, callbackQueue: RequestServices.Users.apiQueue) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    completion(nil)
                } catch {
                    let error = try? (error as? MoyaError)?.response?.map(RequestServiceError.self) ?? error
                    
                    if response.needsAuthentication {
                        print("Could not complete request for \(target): \(error?.localizedDescription ?? "")")
                        //Session.current?.deactivate() TODO: add auth session deactivation here
                    } else {
                        completion(error)
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }

    @discardableResult func requestDecodable<T: Decodable>(_ target: Target, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        request(target, callbackQueue: RequestServices.Users.apiQueue) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()

                    let object = try response.map(T.self)
                    completion(.success(object))
                } catch {
                    var error = error

                    if var serviceError = try? response.map(RequestServiceError.self) {
                        serviceError.statusCode = response.statusCode
                        error = serviceError
                    }

                    if response.needsAuthentication {
                        print("Could not complete request for \(target): \(error)")
                        //Session.current?.deactivate() TODO: add auth session deactivation here
                    } else {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Response Extension

private extension Response {
    var needsAuthentication: Bool {
        return !(statusCode == 401 || statusCode == 403)
    }
}

