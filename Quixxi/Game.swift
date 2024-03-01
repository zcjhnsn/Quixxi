//
//  Game.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/28/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct Game {
    
    @ObservableState
    struct State: Equatable {
        var rows: IdentifiedArrayOf<Row.State> = [ ]
        var strikes = StrikesRow.State()
        @Presents var alert: AlertState<Action.Alert>?
        
        init(rows: IdentifiedArrayOf<Row.State> = [], alert: AlertState<Action.Alert>? = nil) {
            if rows.isEmpty {
                self.rows = [
                    Row.State(id: 0, order: .ascending, dice: .red),
                    Row.State(id: 1, order: .ascending, dice: .yellow),
                    Row.State(id: 2, order: .descending, dice: .green),
                    Row.State(id: 3, order: .descending, dice: .blue)
                ]
            } else {
                self.rows = rows
            }
            self.alert = alert
        }
        
        var totalScore: Int {
            rows.map { $0.score }.reduce(0, +) - strikes.score
        }
    }
    
    enum Action {
        enum Alert {
            case confirmResetTapped
        }
        
        case alert(PresentationAction<Alert>)
        case resetTapped
        case row(IdentifiedActionOf<Row>)
        case strikes(StrikesRow.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.strikes, action: \.strikes) { 
            StrikesRow()
        }
        
        Reduce { state, action in 
            switch action {
            case .alert(.presented(.confirmResetTapped)):
                return .run { send in 
                    for i in 0...3 {
                        await send(.row(
                            .element(id: i, action: .reset)
                        ))
                    }
                    await send(.strikes(.reset))
                }.animation()
                
            case .alert:
                return .none
                
            case .row:
                return .none
                
            case .resetTapped:
                state.alert = AlertState(
                    title: { TextState("Reset Board?") },
                    actions: {
                        ButtonState(role: .destructive, action: .send(.confirmResetTapped, animation: .bouncy(extraBounce: 0.05)), label: { TextState("Reset") })
                    },
                    message: { TextState("This cannot be undone.") }
                )
                return .none
                
            case .strikes:
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
        .forEach(\.rows, action: \.row) {
            Row()
        }
    }
}
