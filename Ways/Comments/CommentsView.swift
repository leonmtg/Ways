//
//  CommentsView.swift
//  Ways
//
//  Created by Leon on 2024/1/16.
//

import SwiftUI
import ComposableArchitecture

struct CommentsView: View {
    let store: StoreOf<CommentsReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NavigationStack {
        CommentsView(
            store: Store(
                initialState: CommentsReducer.State(
                    comments: [
                        
                    ]
                )
            ) {
                CommentsReducer()
            }
        )
    }
}
