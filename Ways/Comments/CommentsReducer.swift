//
//  CommentsReducer.swift
//  Ways
//
//  Created by Leon on 2024/1/16.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CommentsReducer {
    struct State: Equatable {
        let comments: IdentifiedArrayOf<Comment>
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
