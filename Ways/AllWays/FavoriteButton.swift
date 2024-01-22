//
//  FavoriteButton.swift
//  Ways
//
//  Created by Leon on 2024/1/20.
//

import SwiftUI
import ComposableArchitecture

struct FavoriteButton<ID: Hashable & Sendable>: View {
    let store: Store<FavoriteState<ID>, FavoriteAction>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.buttonTapped)
            } label: {
                Image(systemName: "heart")
                    .symbolVariant(viewStore.isFavorite ? .fill : .none)
            }
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        }
    }
}
