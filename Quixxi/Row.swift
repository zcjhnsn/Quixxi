//
//  Row.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/26/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

enum Dice {
    case red, yellow, green, blue
    
    var color: Color {
        switch self {
        case .red: .red
        case .yellow: .yellow
        case .green: .green
        case .blue: .blue
        }
    }
}

@Reducer
struct Row {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: Int
        let dice: Dice
        var boxes: [Box] 
        var isUnlocked: Bool = true
        
        var isLockable: Bool {
            boxes.crossedCount >= 5
        }
        
        var lastCrossed: Int {
            boxes.lastIndex(where: { $0.isCrossed }) ?? -1
        }

        var blueCount: Int {
            boxes.lazy.filter({ $0.dice == .blue && $0.isCrossed }).count
        }

        var greenCount: Int {
            boxes.lazy.filter({ $0.dice == .green && $0.isCrossed }).count
        }

        var redCount: Int {
            boxes.lazy.filter({ $0.dice == .red && $0.isCrossed }).count
        }

        var yellowCount: Int {
            boxes.lazy.filter({ $0.dice == .yellow && $0.isCrossed }).count
        }
    }

    enum Action {
        case boxTapped(Int)
        case lockSwitched(Bool)
        case reset
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in 
            switch action {
            case let .boxTapped(index):
                guard !state.boxes[index].isDisabled else { return .none }
                guard index >= state.lastCrossed else { return .none }
                guard state.boxes[index].isNormal else {
                    return .merge(
                        updateStatus(at: index, state: &state),
                        updateStatuses(toLeftOf: index, state: &state)
                    )
                }
                return .merge(
                    updateStatuses(toLeftOf: index, state: &state),
                    updateStatus(at: index, state: &state)
                )
                
            case let .lockSwitched(isUnlocked):
                state.isUnlocked = isUnlocked
                return updateStatuses(toLeftOf: 12, state: &state)
                
            case .reset:
                for i in 0..<state.boxes.count {
                    state.boxes[i].status = .normal
                }
                state.isUnlocked = true
                return .none.animation()
            }
        }
    }
    
    private func updateStatus(at index: Int, state: inout State) -> Effect<Action> {
        // get current status 
        let isNormal = state.boxes[index].isNormal
        state.boxes[index].status = isNormal ? .crossed : .normal
        return .none
    }
    
    private func updateStatuses(toLeftOf index: Int, state: inout State) -> Effect<Action> {
        for i in (state.lastCrossed + 1)..<index {
            let isBoxDisabled = state.boxes[i].isDisabled
            state.boxes[i].status = isBoxDisabled ? .normal : .disabled
        }
        return .none
    }
}

extension Array where Element == Box {
    var crossedCount: Int {
        self.filter { $0.isCrossed }.count
    }
}
