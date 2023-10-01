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

struct QuestionBlockError: LocalizedError, Decodable, Error {
    let errorMessage: String
    var httpStatus: String { errorMessage }

    var statusCode: Int?
    var blockedTime: Int

    var errorDescription: String? { errorMessage }
    var localizedDescription: String { errorMessage }
}
