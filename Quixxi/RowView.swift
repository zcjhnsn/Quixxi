//
//  RowView.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/27/24.
//

import ComposableArchitecture
import Pow
import SwiftUI

struct RowView: View {
    @Bindable var store: StoreOf<Row>
    
    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                    ForEach(0...9, id: \.self) { number in
                        if !store.boxes[number].isDisabled {
                            Button {
                                store.send(.boxTapped(number), animation: .bouncy(extraBounce: 0.05))
                            } label: { 
                                Image(systemName: image(for: number))
                                    .resizable()
                                    .scaledToFit()
                                    .contentTransition(.symbolEffect(.replace))
                            }
                            .foregroundStyle(store.boxes[number].dice.color)
                            .frame(width: 44)
                            .opacity(store.boxes[number].isNormal ? 0.5 : 1)
                            .disabled(store.boxes[number].isDisabled)
                            .transition(
                                .asymmetric(
                                    insertion: .movingParts.pop(store.boxes[number].dice.color),
                                    removal: .scale
                                )
                            )
                        }
                    }
                    
                    if !store.boxes[10].isDisabled {
                        Button {
                            store.send(.boxTapped(10), animation: .bouncy(extraBounce: 0.05))
                        } label: { 
                            Image(systemName: image(for: 10))
                                .resizable()
                                .scaledToFit()
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .foregroundStyle(store.isLockable ? store.boxes[10].dice.color : .gray)
                        .frame(width: 44)
                        .disabled(!store.isLockable)
                        .opacity(store.boxes[10].isNormal ? 0.5 : 1)
                        .transition(
                            .asymmetric(
                                insertion: .movingParts.pop(store.isLockable ? store.boxes[10].dice.color : .gray.opacity(0.5)),
                                removal: .scale
                            )
                        )
                    }
                    
                    // lock button
                    if !store.boxes[11].isDisabled {
                        Button {
                            store.send(.boxTapped(11), animation: .bouncy(extraBounce: 0.05))
                        } label: { 
                            Image(systemName: image(for: 11))
                                .resizable()
                                .scaledToFit()
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .foregroundStyle(store.isLockable ? store.boxes[11].dice.color : .gray)
                        .disabled(!store.isLockable)
                        .frame(width: 44)
                        .opacity(store.boxes[11].isNormal ? 0.5 : 1)
                        .transition(
                            .asymmetric(
                                insertion: .movingParts.pop(store.isLockable ? store.boxes[11].dice.color : .gray.opacity(0.5)),
                                removal: .scale
                            )
                        )
                    }
                    
                    if !store.isUnlocked {
                        HStack(alignment: .center) {
                            Image(systemName: "figure.child.and.lock.fill")
                                .font(.title)
                            
                            Text("Locked by\nanother player")
                                .font(.system(size: 16))

                            Spacer()
                        }
                        .transition(
                            .asymmetric(insertion: .move(edge: .trailing), removal: .slide)
                            .combined(with: .opacity)
                        )
                        .foregroundStyle(store.dice.color)
                        
                    }

                    Spacer()
                    
                }
                .frame(height: 44)
            
            HStack {
                Spacer()
                
                Toggle(isOn: $store.isUnlocked.sending(\.lockSwitched).animation(.smooth(extraBounce: 0.05)), label: {
                    Text("Lock row via another player")
                })
                .labelsHidden()
                .tint(store.dice.color)
                .disabled(store.isFull)
            }
        }
    }
    
    private func image(for index: Int) -> String {
        let normal = if index == 11 {
            "lock.square"
        } else {
            "\(store.boxes[index].number).square"
        }
        return store.boxes[index].isCrossed ? "x.square.fill" : normal
    }
}

#Preview("Ascending") {
    GeometryReader { geo in 
        VStack {
            RowView(
                store: Store(
                    initialState: Row.State(
                        id: 0,
                        dice: .red,
                        boxes: (2...13).map { Box(number: $0, dice: .red) }
                    ),
                    reducer: Row.init
                )
            )
            .frame(height: 44)
        }
    }
}

#Preview("Descending") {
    VStack {
        RowView(
            store: Store(
                initialState: Row.State(
                    id: 0,
                    dice: .blue,
                    boxes: (1...12).reversed().map { Box(number: $0, dice: .blue) }
                ),
                reducer: Row.init
            )
        )
    }
}
