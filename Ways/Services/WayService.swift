//
//  WayService.swift
//  Ways
//
//  Created by Leon on 2024/1/2.
//

import Foundation
import Combine

protocol WaysPublisherProtocol {
    func waysPublisher() -> AnyPublisher<[Way], HTTPResponseError>
    func ways() async throws -> [Way]
}

struct WayService {
    static let shared = WayService()
    
    private func url() -> URL {
        urlComponents().url!
    }
    
    private func urlComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.ways.dev"
        components.path = "/api/v1/ways"
        
        return components
    }
}

extension WayService: WaysPublisherProtocol {
    func waysPublisher() -> AnyPublisher<[Way], HTTPResponseError> {
        URLSession.shared
            .dataTaskPublisher(for: url())
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPResponseError.unknown
                }
                
                if (400...499).contains(httpResponse.statusCode) {
                    throw HTTPResponseError.clientError(httpResponse.statusCode)
                }
                
                if (500...599).contains(httpResponse.statusCode) {
                    throw HTTPResponseError.serverError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: [Way].self, decoder: JSONDecoder())
            .mapError { error -> HTTPResponseError in
                if let httpResponseError = error as? HTTPResponseError {
                    return httpResponseError
                } else if let decodeError = error as? DecodingError {
                    return HTTPResponseError.decodeError(decodeError)
                } else {
                    return HTTPResponseError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
    func ways() async throws -> [Way] {
        let asyncSequence = waysPublisher().values
        
        for try await value in asyncSequence {
            return value
        }
        
        assertionFailure("We should never arrive here!")
        return []
    }
}


