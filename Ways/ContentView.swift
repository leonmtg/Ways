//
//  ContentView.swift
//  Ways
//
//  Created by Leon on 2023/12/20.
//

import SwiftUI
import Dependencies
import SwiftData

struct ContentView: View {
    @Dependency(\.database) var database
    var modelContext: ModelContext {
        guard let modelContext = try? self.database.modelContext() else {
            fatalError("Could not find modelContext")
        }
        return modelContext
    }
    
    var body: some View {
        TabView {
            MyWays()
                .tabItem {
                    Label("My Ways", systemImage: "lightbulb.min")
                        .environment(\.symbolVariants, .none)
                }
            
            AllWaysView(store: .init(initialState: .init(), reducer: {
                AllWaysReducer()
                    ._printChanges()
            }))
            .modelContext(self.modelContext)
            .tabItem {
                Label("All Ways", systemImage: "infinity")
            }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person")
                        .environment(\.symbolVariants, .none)
                }
        }
    }
}

#Preview {
    ContentView()
}
