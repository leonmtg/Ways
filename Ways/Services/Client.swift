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
    var favoriteWay: @Sendable (Way.ID, Bool) async throws -> Bool
}

extension Client: DependencyKey {
    static let liveValue = Self(
        allWay: mockAllWays,
        way: mockWay,
        favoriteWay: mockFavoriteWay
    )
    static let testValue = Self(
        allWay: mockAllWays,
        way: mockWay,
        favoriteWay: mockFavoriteWay
    )
    static let previewValue = Self(
        allWay: mockAllWays,
        way: mockWay,
        favoriteWay: mockFavoriteWay
    )
}

extension DependencyValues {
    var client: Client {
        get { self[Client.self] }
        set { self[Client.self] = newValue }
    }
}

fileprivate let mockAllWays: () async throws -> [Way] = {
    return {
        guard let url = Bundle.main.url(forResource: "allWays", withExtension: "json") else {
            fatalError("Failed to find allWays.json")
        }
        try await Task.sleep(for: .seconds(1))
        
        let data = try Data(contentsOf: url)
        let ways = try JSONDecoder.decoderWithStrategy.decode([Way].self, from: data)
        return ways
    }
}()

fileprivate let mockWay: (Int) async throws -> Way = {
    return { _ in
        guard let url = Bundle.main.url(forResource: "way", withExtension: "json") else {
            fatalError("Failed to find way.json")
        }
        try await Task.sleep(for: .seconds(1))
        
        let data = try Data(contentsOf: url)
        let way = try JSONDecoder.decoderWithStrategy.decode(Way.self, from: data)
        return way
    }
}()

struct FavoriteError: LocalizedError, Equatable {
    var errorDescription: String? {
        "Favoriting failed."
    }
}

fileprivate let mockFavoriteWay: @Sendable (Way.ID, Bool) async throws -> Bool = {
    return { _, isFavorite in
        try await Task.sleep(for: .seconds(1))
        if .random(in: 0...1) > 0.2 {
            return isFavorite
        } else {
            throw FavoriteError()
        }
    }
}()


