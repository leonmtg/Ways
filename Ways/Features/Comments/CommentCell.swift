//
//  CommentCell.swift
//  Ways
//
//  Created by Leon on 2024/2/2.
//

import SwiftUI
import ComposableArchitecture

struct CommentCell: View {
    let store: StoreOf<CommentReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CommentCell(
        store: Store(
            initialState: CommentReducer.State(
                comment: Comment(
                    score: 5,
                    subject: "Example Subject",
                    date: Date(),
                    comment: "It's a very good way to learn a whole new language!",
                    commenter: "Leon"
                )
            )
        ) {
            CommentReducer()
        }
    )
}
