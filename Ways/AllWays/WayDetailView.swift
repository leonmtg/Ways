//
//  WayDetailView.swift
//  Ways
//
//  Created by Leon on 2023/12/26.
//

import SwiftUI
import ComposableArchitecture

struct WayDetailView: View {
    let store: StoreOf<WayDetailReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Text(viewStore.way.summary)
                HStack(alignment: .firstTextBaseline) {
                    Text("Favorite")
                    
                    Spacer()
                    
                    FavoriteButton(store: self.store.scope(state: \.favorite, action: \.favorite))
                }
                .buttonStyle(.borderless)
                Button("Delete") {
                    viewStore.send(.deleteButtonTapped)
                }
            }
            .navigationTitle(Text(viewStore.way.name))
        }
        .alert(store: self.store.scope(state: \.$alert, action: \.alert))
    }
}

#Preview {
    let context = onlyMemoryContext // Must access container or context first here before use Models
    
    return NavigationStack {
        WayDetailView(
            store: Store(
                initialState: WayDetailReducer.State(
                    way: Way(
                        id: 666,
                        name: "Example Way",
                        summary: "Example Way is just a placeholder here.",
                        tags: [],
                        isFavorite: false
                    )
                )
            ) {
                WayDetailReducer(favorite: favorite(id:isFavorite:))
            }
        )
    }
    .modelContext(context)
}

struct FavoriteError: LocalizedError, Equatable {
    var errorDescription: String? {
        "Favoriting failed."
    }
}

// TODO: WIP
@Sendable func favorite<ID>(id: ID, isFavorite: Bool) async throws -> Bool {
    try await Task.sleep(for: .seconds(1))
    if .random(in: 0...1) > 0.25 {
        return isFavorite
    } else {
        throw FavoriteError()
    }
}
