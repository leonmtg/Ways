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
    }
    enum Action {
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
    
    var body: some ReducerOf<Self> {
        Scope(state: \.favorite, action: \.favorite) {
            FavoriteReducer(favorite: self.client.favoriteWay)
        }
        Reduce { state, action in
            switch action {
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
