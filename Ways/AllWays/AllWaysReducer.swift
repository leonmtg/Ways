//
//  AllWaysReducer.swift
//  Ways
//
//  Created by Leon on 2023/12/23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AllWaysReducer {
    struct State: Equatable {
        var ways: [Way] = []
    }
    
    enum Action: Equatable {
        case queryChangedWays([Way])
        case addWay
        case deleteWay(Way)
    }
    
    @Dependency(\.wayContext) var context
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .queryChangedWays(ways):
                state.ways = ways
                return .none
            case .addWay:
                do {
                    let randomWayName = ["Duolingo", "Anki", "Harry Potter", "Lord of the Rings", "Berliner Platz"].randomElement()!
                    try context.add(.init(name: randomWayName, tags: []))
                } catch {
                    print("Failed to add")
                }
                return .none
            case let .deleteWay(wayToDelete):
                do {
                    try context.delete(wayToDelete)
                } catch {
                    print("Failed to delete")
                }
                return .none
            }
        }
    }
}
