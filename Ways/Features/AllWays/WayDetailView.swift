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
        .onFirstAppear {
            self.store.send(.setNavigation(isActive: true))
        }
        .onDisappear { // TODO: We need a better event handler here.
            self.store.send(.setNavigation(isActive: false))
        }
    }
}

#Preview {
    @Dependency(\.database) var database
    let context = database.modelContext() // Must access container or context first here before use Models
    
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
                WayDetailReducer()
            }
        )
    }
    .modelContext(context)
}
