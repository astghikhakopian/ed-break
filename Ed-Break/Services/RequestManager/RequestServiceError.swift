//
//  RequestServiceError.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation

struct RequestServiceError: LocalizedError, Decodable, Error {
    let message: String
    let httpStatus: String

    var statusCode: Int?

    var errorDescription: String? { message }
    var localizedDescription: String { message }
}
