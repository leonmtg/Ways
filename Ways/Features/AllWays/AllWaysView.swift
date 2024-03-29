//
//  AllWaysView.swift
//  Ways
//
//  Created by Leon on 2023/12/21.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

struct AllWaysView: View {
    let store: StoreOf<AllWaysReducer>
    
    @Query(FetchDescriptor<Way>()) var ways: [Way]
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            WithViewStore(store, observe: \.ways) { viewStore in
                List {
                    ForEach(viewStore.state) { way in
                        NavigationLink(state: WayDetailReducer.State(way: way)) {
                            VStack {
                                Text("\(way.name)").font(.title)
                            }
                            .swipeActions {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    viewStore.send(.deleteWay(way), animation: .snappy)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Ways")
                .toolbar {
                    Button("Add sample", systemImage: "plus") {
                        viewStore.send(.addWay, animation: .snappy)
                    }
                }
                .onChange(of: self.ways, initial: true) { _, newValue in
                    viewStore.send(.queryWaysChanged(newValue))
                }
            }
        } destination: { store in
            WayDetailView(store: store)
        }
    }
}

#Preview {
    @Dependency(\.database) var database
    let context = database.modelContext() // Must access container or context first here before use Models
    
    return TabView {
        AllWaysView(
            store: Store(
                initialState: AllWaysReducer.State(
                    ways: []
                )
            ) {
                AllWaysReducer()
            }
        )
        .modelContext(context)
        .tabItem {
            Label("All Ways", systemImage: "infinity")
        }
    }
}
