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
        var rows: IdentifiedArrayOf<Row.State> = .init(uniqueElements: .normal)
        var strikes = StrikesRow.State()
        var mode: Mode = .normal
        @Presents var alert: AlertState<Action.Alert>?
        
        init(rows: IdentifiedArrayOf<Row.State> = .init(uniqueElements: .normal)) { 
            self.rows = rows
        }
        
        var totalScore: Int {
            rows.map { $0.score }.reduce(0, +) - strikes.score
        }
    }
    
    enum Action: BindableAction {
        enum Alert {
            case confirmResetTapped
        }
        
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case resetTapped
        case row(IdentifiedActionOf<Row>)
        case strikes(StrikesRow.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.strikes, action: \.strikes) { 
            StrikesRow()
        }
        
        BindingReducer()
            .onChange(of: \.mode) { oldValue, newValue in
                Reduce { state, action in 
                    guard newValue != oldValue else { return .none }
                    switch state.mode {
                    case .normal:
                        state.rows = .init(uniqueElements: .normal)
                    case .mixedColors:
                        state.rows = .init(uniqueElements: .mixedColors)
                    case .mixedNumbers:
                        state.rows = .init(uniqueElements: .mixedNumbers)
                    }
                    return .none
                }
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
                
            case .binding:
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

extension Sequence where Self == [Dice] {
    static var mixedColorRed: [Dice] {
        [
            Array(repeating: Dice.yellow, count: 3),
            Array(repeating: Dice.blue, count: 3),
            Array(repeating: Dice.green, count: 3),
            Array(repeating: Dice.red, count: 3),
        ].flatMap { $0 }
    }
    static var mixedColorYellow: [Dice] {
        [
            Array(repeating: Dice.red, count: 2),
            Array(repeating: Dice.green, count: 4),
            Array(repeating: Dice.blue, count: 2),
            Array(repeating: Dice.yellow, count: 4),
        ].flatMap { $0 }
    }
    static var mixedColorGreen: [Dice] {
        [
            Array(repeating: Dice.blue, count: 3),
            Array(repeating: Dice.yellow, count: 3),
            Array(repeating: Dice.red, count: 3),
            Array(repeating: Dice.green, count: 3),
        ].flatMap { $0 }
    }
    static var mixedColorBlue: [Dice] {
        [
            Array(repeating: Dice.green, count: 2),
            Array(repeating: Dice.red, count: 4),
            Array(repeating: Dice.yellow, count: 2),
            Array(repeating: Dice.blue, count: 4),
        ].flatMap { $0 }
    }
    
    
}

extension Sequence where Self == [Row.State] {
    static var normal: [Row.State] { 
        [
            Row.State(id: 0, dice: .red, boxes: (2...13).map { Box(number: $0, dice: .red) }),
            Row.State(id: 1, dice: .yellow, boxes: (2...13).map { Box(number: $0, dice: .yellow) }),
            Row.State(id: 2, dice: .green, boxes: (1...12).reversed().map { Box(number: $0, dice: .green) }),
            Row.State(id: 3, dice: .blue, boxes: (1...12).reversed().map { Box(number: $0, dice: .blue) })
        ]
    }
    
    static var mixedColors: [Row.State] {
        [
            Row.State(
                id: 0,
                dice: .red,
                boxes: zip((2...13), .mixedColorRed).map { Box(number: $0, dice: $1) }
            ),
            Row.State(
                id: 1,
                dice: .yellow,
                boxes: zip((2...13), .mixedColorYellow).map { Box(number: $0, dice: $1) }
            ),
            Row.State(
                id: 2,
                dice: .green,
                boxes: zip((1...12).reversed(), .mixedColorGreen).map { Box(number: $0, dice: $1) }
            ),
            Row.State(
                id: 3,
                dice: .blue,
                boxes: zip((1...12).reversed(), .mixedColorBlue).map { Box(number: $0, dice: $1) }
            ),
        ]
    }
    
    static var mixedNumbers: [Row.State] {
        [
            Row.State(
                id: 0,
                dice: .red,
                boxes: [10, 6, 2, 8, 3, 4, 12, 5, 9, 7, 11, 13].map { Box(number: $0, dice: .red) }
            ),
            Row.State(
                id: 1,
                dice: .yellow,
                boxes: [9, 12, 4, 6, 7, 2, 5, 8, 11, 3, 10, 13].map { Box(number: $0, dice: .yellow) }
            ),
            Row.State(
                id: 2,
                dice: .green,
                boxes: [8, 2, 10, 12, 6, 9, 7, 4, 5, 11, 3, 13].map { Box(number: $0, dice: .green) }
            ),
            Row.State(
                id: 3,
                dice: .blue,
                boxes: [5, 7, 11, 9, 12, 3, 8, 10, 2, 6, 4, 13].map { Box(number: $0, dice: .blue) }
            ),
        ]
    }
}

//extension Array where Element == Row.State {
//    static var normal: [Row.State] = [
//        Row.State(id: 0, dice: .red, boxes: (2...13).map { Box(number: $0, dice: .red) }),
//        Row.State(id: 1, dice: .red, boxes: (2...13).map { Box(number: $0, dice: .yellow) }),
//        Row.State(id: 2, dice: .red, boxes: (12...1).map { Box(number: $0, dice: .green) }),
//        Row.State(id: 3, dice: .red, boxes: (12...1).map { Box(number: $0, dice: .blue) })
//    ]
//}
