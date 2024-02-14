//
//  NavigateAndLoadReducer.swift
//  Ways
//
//  Created by Leon on 2024/2/5.
//

import Foundation
import ComposableArchitecture

struct NavigateAndLoadState<Content: Reducer>: Equatable where Content.State: Equatable {
    @PresentationState var alert: AlertState<NavigateAndLoadAction<Content>.Alert>?
    var isNavigationActive = false
    var optionalContent: Content.State?
}

@CasePathable
enum NavigateAndLoadAction<Content: Reducer> {
    case optionalContent(Content.Action)
    case alert(PresentationAction<Alert>)
    case setNavigation(isActive: Bool)
    case response(Result<Content.State, Error>)
    
    enum Alert: Equatable {}
}

@Reducer
struct NavigateAndLoadReducer<Content: Reducer> where Content.State: Equatable {
    let load: @Sendable () async throws -> Content.State
    
    private enum CancelID {
        case load
    }
    
    var body: some Reducer<NavigateAndLoadState<Content>, NavigateAndLoadAction<Content>> {
        Reduce { state, action in
            switch action {
            case .alert(.dismiss):
                state.alert = nil
                return .none
                
            case .setNavigation(isActive: true):
                state.isNavigationActive = true
                return .run { send in
                    await send(.response(Result { try await load() } ))
                }
                .cancellable(id: CancelID.load, cancelInFlight: true)
                
            case .setNavigation(isActive: false):
                state.isNavigationActive = false
                state.optionalContent = nil
                return .cancel(id: CancelID.load)
                
            case let .response(.failure(error)):
                state.alert = AlertState { TextState(error.localizedDescription) }
                return .none
            
            case let .response(.success(contentState)):
                state.optionalContent = contentState
                return .none
                
            case .optionalContent:
                return .none
            }
        }
//        .ifLet(\.optionalContent, action: \.optionalContent) {
//            Content()
//        }
    }
}
