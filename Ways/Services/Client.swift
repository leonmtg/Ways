//
//  Client.swift
//  Ways
//
//  Created by Leon on 2024/1/1.
//

import Foundation
import Dependencies

struct Client {
    var allWay: () async throws -> [Way]
    var way: (Int) async throws -> Way
}

extension Client: DependencyKey {
    static let liveValue = Self(
        allWay: loadLocalAllWays,
        way: loadLocalWay
    )
    static let testValue = Self(
        allWay: loadLocalAllWays,
        way: loadLocalWay
    )
    static let previewValue = Self(
        allWay: loadLocalAllWays,
        way: loadLocalWay
    )
}

extension DependencyValues {
    var client: Client {
        get { self[Client.self] }
        set { self[Client.self] = newValue }
    }
}

fileprivate let loadLocalAllWays = {
    return {
        guard let url = Bundle.main.url(forResource: "allWays", withExtension: "json") else {
            fatalError("Failed to find allWays.json")
        }
        let data = try Data(contentsOf: url)
        let ways = try JSONDecoder.decoderWithStrategy.decode([Way].self, from: data)
        return ways
    }
}()

fileprivate let loadLocalWay: (Int) async throws -> Way = {
    return { _ in
        guard let url = Bundle.main.url(forResource: "way", withExtension: "json") else {
            fatalError("Failed to find way.json")
        }
        let data = try Data(contentsOf: url)
        let way = try JSONDecoder.decoderWithStrategy.decode(Way.self, from: data)
        return way
    }
}()


