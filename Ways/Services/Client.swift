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
    var way: (Way.ID) async throws -> Way
    var favoriteWay: @Sendable (Way.ID, Bool) async throws -> Bool
    var waySupplementary: (Way.ID) async throws -> [Comment]
}

extension Client: DependencyKey {
    static let liveValue = Self(
        allWay: mockAllWays,
        way: mockWay,
        favoriteWay: mockFavoriteWay,
        waySupplementary: mockWaySupplementary
    )
    static let testValue = Self(
        allWay: mockAllWays,
        way: mockWay,
        favoriteWay: mockFavoriteWay,
        waySupplementary: mockWaySupplementary
    )
    static let previewValue = Self(
        allWay: mockAllWays,
        way: mockWay,
        favoriteWay: mockFavoriteWay,
        waySupplementary: mockWaySupplementary
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

fileprivate let mockWay: (Way.ID) async throws -> Way = {
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


fileprivate let mockWaySupplementary: (Way.ID) async throws -> [Comment] = {
    return { _ in
        guard let url = Bundle.main.url(forResource: "waySupplementary", withExtension: "json") else {
            fatalError("Failed to find waySupplementary.json")
        }
        try await Task.sleep(for: .seconds(1))
        
        let data = try Data(contentsOf: url)
        let comments = try JSONDecoder.decoderWithStrategy.decode([Comment].self, from: data)
        return comments
    }
}()

