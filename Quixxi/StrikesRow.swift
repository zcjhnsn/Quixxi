//
//  StrikesRow.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/29/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct StrikesRow {
    
    @ObservableState
    struct State: Equatable {
        var boxes: [Box] = Array(repeating: Box(number: 0, dice: .red), count: 4)
        
        var lastCrossed: Int {
            boxes.lastIndex(where: { $0.isCrossed }) ?? -1
        }
        
        var score: Int {
            boxes.crossedCount * 5
        }
    }
    
    enum Action {
        case boxTapped(Int)
        case reset
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in 
            switch action {
            case let .boxTapped(index):
                guard index == state.lastCrossed + 1 || index == state.lastCrossed else { return .none }
                state.boxes[index].status = state.boxes[index].isNormal ? .crossed : .normal
                return .none
                
            case .reset:
                state.boxes = Array(repeating: Box(number: 0, dice: .red), count: 4)
                return .none
            }
        }
    }
}
