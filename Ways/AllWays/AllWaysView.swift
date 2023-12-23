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
    
    @Query(FetchDescriptor<Way>()) var ways: [Way] {
        didSet {
            print(oldValue)
            print(newValue)
            store.send(.queryChangedWays(newValue))
        }
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
                    ForEach(self.ways) { way in
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
                .navigationTitle("Ways Query")
                .toolbar {
                    Button("Add sample", systemImage: "plus") {
                        viewStore.send(.addWay, animation: .snappy)
                    }
                }
            }
        }
    }
}

#Preview {
    TabView {
        AllWaysView(
            store: Store(
                initialState: AllWaysReducer.State(
                    ways: []
                )
            ) {
                AllWaysReducer()
            }
        )
        .modelContext(onlyMemoryContext)
        .tabItem {
            Label("All Ways", systemImage: "infinity")
        }
    }
}
