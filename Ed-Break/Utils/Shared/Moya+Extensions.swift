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
        request(target, callbackQueue: RequestServices.Users.apiQueue) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    if let json = try? JSONSerialization.jsonObject(with: response.data) {
                        print(json)
                    }
                    _ = try response.filterSuccessfulStatusCodes()
                    completion(nil)
                } catch {
                    let error = try? (error as? MoyaError)?.response?.map(RequestServiceError.self) ?? error
                    
                    if response.needsAuthentication {
                        print("Could not complete request for \(target): \(error?.localizedDescription ?? "")")
                        self?.refreshToken()
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
        print(target)
        return request(target, callbackQueue: RequestServices.Users.apiQueue) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    if let json = try? JSONSerialization.jsonObject(with: response.data) {
                        print(json)
                    }
                    print(String(data: response.data, encoding: .utf8) ?? "")
                    _ = try response.filterSuccessfulStatusCodes()

                    let object = try response.map(T.self)
                    completion(.success(object))
                } catch {
                    var error = error
                    print(error)
                    if var serviceError = try? response.map(RequestServiceError.self) {
                        serviceError.statusCode = response.statusCode
                        error = serviceError
                    }

                    if response.needsAuthentication {
                        print("Could not complete request for \(target): \(error)")
                        completion(.failure(error))
                        self?.refreshToken()
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
    
    private func refreshToken() {
        let refreshTokenUseCase = RefreshTokenUseCase(familySharingRepository: DefaultFamilySharingRepository())
        let localStorageService = UserDefaultsService()
        refreshTokenUseCase.execute { result in
            switch result {
            case .success(let token):
                localStorageService.setObject(token, forKey: .User.token)
                localStorageService.setPrimitive(true, forKey: .User.isLoggedIn)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

// MARK: - Response Extension

private extension Response {
    var needsAuthentication: Bool {
        return (statusCode == 401 || statusCode == 403)
    }
}

