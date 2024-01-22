//
//  FavoriteReducer.swift
//  Ways
//
//  Created by Leon on 2024/1/20.
//

import Foundation
import ComposableArchitecture

struct FavoriteState<ID: Hashable & Sendable>: Equatable {
    @PresentationState var alert: AlertState<FavoriteAction.Alert>?
    let id: ID
    var isFavorite: Bool
}

@CasePathable
enum FavoriteAction {
    case alert(PresentationAction<Alert>)
    case buttonTapped
    case response(Result<Bool, Error>)

    enum Alert: Equatable {}
}

@Reducer
struct FavoriteReducer<ID: Hashable & Sendable> {
    let favorite: @Sendable (ID, Bool) async throws -> Bool
    
    private struct CancelID: Hashable {
        let id: AnyHashable
    }
    
    var body: some Reducer<FavoriteState<ID>, FavoriteAction> {
        Reduce { state, action in
            switch action {
            case .alert(.dismiss):
                state.alert = nil
                state.isFavorite.toggle()
                return .none
                
            case .buttonTapped:
                state.isFavorite.toggle()
                
                return .run { [id = state.id, isFavoirte = state.isFavorite, favorite] send in
                    await send(.response(Result { try await favorite(id, isFavoirte) }))
                }
                .cancellable(id: CancelID(id: state.id), cancelInFlight: true)
            
            case let .response(.failure(error)):
                state.alert = AlertState { TextState(error.localizedDescription) }
                return .none
                
            case let .response(.success(isFavorite)):
                state.isFavorite = isFavorite
                return .none
            }
        }
    }
}
