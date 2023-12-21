//
//  ContentView.swift
//  Ways
//
//  Created by Leon on 2023/12/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MyWays()
                .tabItem {
                    Label("My Ways", systemImage: "lightbulb.min")
                        .environment(\.symbolVariants, .none)
                }
            AllWaysView()
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
