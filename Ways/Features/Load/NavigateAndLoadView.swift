//
//  NavigateAndLoadView.swift
//  Ways
//
//  Created by Leon on 2024/2/5.
//

import SwiftUI
import ComposableArchitecture

struct NavigateAndLoadView<ContentView: View, Content: Reducer>: View  where Content.State: Equatable {
    @Bindable var store: StoreOf<NavigateAndLoadReducer<Content>>
    
    @ViewBuilder var contentViewBuilder: (StoreOf<Content>) -> ContentView
    
    var body: some View {
        IfLetStore(store.scope(state: \.optionalContent, action: \.optionalContent)) {
            contentViewBuilder($0)
        } else: {
            ProgressView()
        }
    }
}

//#Preview {
//    NavigateAndLoadView()
//}

//protocol StoreSettableView: View {
//    associatedtype Content: Reducer
//    
//    var store: Content { get set }
//}
