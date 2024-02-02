//
//  CommentReducer.swift
//  Ways
//
//  Created by Leon on 2024/2/2.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CommentReducer {
    struct State: Equatable {
        let comment: Comment
    }
    
    enum Action {
        case expand
        case delegate(Delegate)
        
        enum Delegate {
            case expand
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .expand:
                return .run { send in
                    await send(.delegate(.expand))
                }
            case .delegate:
                return .none
            }
        }
    }
}
