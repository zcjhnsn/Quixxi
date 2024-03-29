//
//  GameView.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/29/24.
//

import ComposableArchitecture
import SwiftUI

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
            Button { 
                store.send(.resetTapped, animation: .bouncy(extraBounce: 0.05))
            } label: { 
                Text("Reset")
                    .padding(.horizontal)
                    .foregroundStyle(.red)
            }
            .buttonStyle(.bordered)
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    var redScore: Text {
        Text("\(store.rows[id: 0]?.score ?? 0)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.red)
    }
    
    var yellowScore: Text {
        Text("\(store.rows[id: 1]?.score ?? 0)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.yellow)
    }
    
    var greenScore: Text {
        Text("\(store.rows[id: 2]?.score ?? 0)")
            .font(.system(.title, design: .rounded))
            .foregroundStyle(.green)
    }
    
    var blueScore: Text {
        Text("\(store.rows[id: 3]?.score ?? 0)")
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
            initialState: Game.State(),
            reducer: Game.init
        )
    )
}
