//
//  WayDetailReducer.swift
//  Ways
//
//  Created by Leon on 2023/12/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WayDetailReducer {
    struct State: Equatable {
        let way: Way
        @PresentationState var alert: AlertState<Action.Alert>?
        
        var favoriteAlert: AlertState<FavoriteAction.Alert>?
        var favorite: FavoriteState<Way.ID> {
            get { .init(alert: self.favoriteAlert, id: way.id, isFavorite: way.isFavorite) }
            set { (self.favoriteAlert, way.isFavorite) = (newValue.alert, newValue.isFavorite) }
        }
        
        var isNavigationActive = false
        var isLoading = false
        var comments: [Comment]?
    }
    enum Action {
        case setNavigation(isActive: Bool)
        case response(Result<[Comment], Error>)
        
        case deleteButtonTapped
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case favorite(FavoriteAction)
        
        enum Alert {
          case confirmDeletion
        }
        enum Delegate {
          case confirmDeletion
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.client) var client
    
    private enum CancelID {
        case load
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.favorite, action: \.favorite) {
            FavoriteReducer(favorite: self.client.favoriteWay)
        }
        
        Reduce { state, action in
            switch action {
            case .setNavigation(isActive: true):
                state.isNavigationActive = true
                let id = state.way.id
                return .run { send in
                    await send(.response(Result { try await self.client.waySupplementary(id) } ))
                }
                .cancellable(id: CancelID.load, cancelInFlight: true)
            case .setNavigation(isActive: false):
                state.isNavigationActive = false
                return .cancel(id: CancelID.load)
                
            case let .response(.failure(error)):
                state.isLoading = false
                return .none
            
            case let .response(.success(comments)):
                state.comments = comments
                state.isLoading = false
                return .none
                
            case .deleteButtonTapped:
                state.alert = AlertState.confirmDeletion
                return .none
            case .alert(.presented(.confirmDeletion)):
                return .run { send in
                    await send(.delegate(.confirmDeletion))
                    await self.dismiss()
                }
            case .alert:
                return .none
            case .delegate:
                return .none
            case .favorite(_):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AlertState where Action == WayDetailReducer.Action.Alert {
  static let confirmDeletion = Self {
    TextState("Are you sure?")
  } actions: {
    ButtonState(role: .destructive, action: .confirmDeletion) {
      TextState("Delete")
    }
  }
}
