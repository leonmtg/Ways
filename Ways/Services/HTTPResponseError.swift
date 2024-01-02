//
//  HTTPResponseError.swift
//  Ways
//
//  Created by Leon on 2024/1/2.
//

import Foundation

enum HTTPResponseError: Error {
    case clientError(_ statusCode:Int)
    case serverError(_ statusCode: Int)
    case decodeError(_ error: DecodingError)
    case unknown
}

extension HTTPResponseError: CustomStringConvertible {
    var description: String {
        switch self {
        case .clientError(let statusCode):
            return "Request Error - \(statusCode)"
        case .serverError(let statusCode):
            return "Server Error - \(statusCode)"
        case .decodeError(let error):
            return "JSON Decode Error - \(error)"
        case .unknown:
            return "Unknown Error"
        }
    }
}

extension HTTPResponseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .clientError:
            return NSLocalizedString("Problem getting the information.", comment: "Client Error")
        case .serverError:
            return NSLocalizedString("Problem with the server.", comment: "Server Error")
        case .decodeError:
            return NSLocalizedString("Problem reading the returned data.", comment: "Decode Error")
        case .unknown:
            return NSLocalizedString("Error couldn't be recognized.", comment: "Unknown")
        }
    }
}
