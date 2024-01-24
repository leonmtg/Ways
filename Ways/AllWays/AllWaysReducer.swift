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
        var path = StackState<WayDetailReducer.State>()
    }
    
    enum Action {
        case queryWaysChanged([Way])
        case addWay
        case deleteWay(Way)
        case path(StackAction<WayDetailReducer.State, WayDetailReducer.Action>)
    }
    
    @Dependency(\.wayContext) var context
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .queryWaysChanged(ways):
                state.ways = ways
                return .none
            case .addWay:
                do {
                    let names = ["Duolingo", "Anki", "Harry Potter", "Lord of the Rings", "Berliner Platz"]
                    let randomWayName = names.randomElement()!
                    // TODO: Need to be deleted!
                    let lastId = state.ways.last?.id ?? 0
                    try context.add(.init(id:lastId + 1, name: randomWayName, summary: "No Summary", tags: [], isFavorite: false))
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
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
          WayDetailReducer()
        }
    }
}
