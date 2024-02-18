//
//  ViewFirstAppearModifier.swift
//  Ways
//
//  Created by Leon on 2024/2/18.
//

import SwiftUI

struct ViewFirstAppearModifier: ViewModifier {
    @State private var didFirstAppear = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didFirstAppear == false {
                didFirstAppear = true
                action?()
            }
        }
    }
}

extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }
}
