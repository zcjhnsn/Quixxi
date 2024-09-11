//
//  GameView.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/29/24.
//

import ComposableArchitecture
import SwiftUI

enum Mode: String, CaseIterable, Equatable, Hashable {
    case normal = "Normal"
    case mixedColors = "Mixed Colors"
    case mixedNumbers = "Mixed Numbers"
}

struct GameView: View {
    @Bindable var store: StoreOf<Game>
    
    var body: some View {
        VStack(alignment: .center) {
            ForEach(store.scope(state: \.rows, action: \.row)) {
                RowView(store: $0)
            }
            
            HStack {
                HStack {
                    redScore
                        .contentTransition(.numericText())
                    Text("+")
                    yellowScore
                        .contentTransition(.numericText())
                    Text("+")
                    greenScore
                        .contentTransition(.numericText())
                    Text("+")
                    blueScore
                        .contentTransition(.numericText())
                    Text("-")
                    strikeScore
                        .contentTransition(.numericText())
                    Text("=")
                    totalScore
                        .contentTransition(.numericText())
                }
                
                Spacer()
                
                StrikesRowView(store: store.scope(state: \.strikes, action: \.strikes))
                    .frame(height: 44)
            }
            .padding(.top, 1)
        }
        .safeAreaPadding(.all)
        .safeAreaInset(edge: .bottom) { 
            HStack {
                Button { 
                    store.send(.resetTapped, animation: .bouncy(extraBounce: 0.05))
                } label: { 
                    Text("Reset")
                        .padding(.horizontal)
                        .foregroundStyle(.red)
                }
                .buttonStyle(.bordered)
                
                Spacer()

                DiceView(
                    showRed: !(store.rows[id: 0]?.isComplete ?? false),
                    showYellow: !(store.rows[id: 1]?.isComplete ?? true),
                    showGreen: !(store.rows[id: 2]?.isComplete ?? true),
                    showBlue: !(store.rows[id: 3]?.isComplete ?? true)
                )

                Spacer()

                Text("Mode:")
                
                Picker(selection: $store.mode) { 
                    ForEach(Mode.allCases, id: \.self) { mode in
                        Text("\(mode.rawValue)")
                    }
                } label: { 
                    Text("Game Mode")
                }

            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    var redScore: Text {
        Text("\(store.redScore)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.red)
    }
    
    var yellowScore: Text {
        Text("\(store.yellowScore)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.yellow)
    }
    
    var greenScore: Text {
        Text("\(store.greenScore)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.green)
    }
    
    var blueScore: Text {
        Text("\(store.blueScore)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.blue)
    }
    
    var strikeScore: Text {
        Text("\(store.strikes.score)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.secondary)
    }
    
    var totalScore: Text {
        Text("\(store.totalScore)")
            .font(.system(.title, design: .rounded, weight: .bold))
            .foregroundStyle(.primary)
    }
}

#Preview {
    GameView(
        store: Store(
            initialState: Game.State(rows: .init(uniqueElements: .normal)),
            reducer: Game.init
        )
    )
}
