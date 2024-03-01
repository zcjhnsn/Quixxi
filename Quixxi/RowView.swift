//
//  RowView.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/27/24.
//

import ComposableArchitecture
import SwiftUI

struct RowView: View {
    @Bindable var store: StoreOf<Row>
    
    private var leftmost: Int {
        store.order == .ascending ? 0 : 9
    }
    
    private var rightmost: Int {
        store.order == .ascending ? 12 : 9
    }
    
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
                            }
                            .foregroundStyle(store.dice.color)
                            .frame(width: 44)
                            .opacity(store.boxes[number].isNormal ? 0.5 : 1)
                            .disabled(store.boxes[number].isDisabled)
                            
                        }
                    }
                    
                    if !store.boxes[10].isDisabled {
                        Button {
                            store.send(.boxTapped(10), animation: .bouncy(extraBounce: 0.05))
                        } label: { 
                            Image(systemName: image(for: 10))
                                .resizable()
                                .scaledToFit()
                        }
                        .foregroundStyle(store.isLockable ? store.dice.color : .gray)
                        .frame(width: 44)
                        .disabled(!store.isLockable)
                        .opacity(store.boxes[10].isNormal ? 0.5 : 1)
                    }
                    
                    if !store.boxes[11].isDisabled {
                        Button {
                            store.send(.boxTapped(11), animation: .bouncy(extraBounce: 0.05))
                        } label: { 
                            Image(systemName: image(for: 11))
                                .resizable()
                                .scaledToFit()
                        }
                        .foregroundStyle(store.isLockable ? store.dice.color : .gray)
                        .disabled(!store.isLockable)
                        .frame(width: 44)
                        .opacity(store.boxes[11].isNormal ? 0.5 : 1)
                    }
                    
                    if !store.isUnlocked {
                        HStack(alignment: .center) {
                            Image(systemName: "figure.child.and.lock.fill")
                                .font(.title)
                            
                            Text("Locked by\nanother player")
                            
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
                    Text("lock row via another player")
                })
                .labelsHidden()
                .disabled(store.isLockable)
                .tint(store.dice.color)
            }
        }
    }
    
    private func image(for index: Int) -> String {
        let normal = if index == 11 {
            "lock.square"
        } else {
            "\(displayNumber(for: index)).square"
        }
        return store.boxes[index].isCrossed ? "x.square.fill" : normal
    }
    
    private func displayNumber(for number: Int) -> Int {
        store.order == .ascending ? number + 2 : 12 - number
    }
}

#Preview("Ascending") {
    GeometryReader { geo in 
        VStack {
            RowView(
                store: Store(
                    initialState: Row.State(
                        id: 0,
                        order: .ascending,
                        dice: .red
                    ),
                    reducer: Row.init
                )
            )
            .frame(height: 44)
            RowView(
                store: Store(
                    initialState: Row.State(
                        id: 1,
                        order: .ascending,
                        dice: .yellow
                    ),
                    reducer: Row.init
                )
            )
            .frame(height: 44)
            RowView(
                store: Store(
                    initialState: Row.State(
                        id: 2,
                        order: .descending,
                        dice: .green
                    ),
                    reducer: Row.init
                )
            )
            .frame(height: 44)
            RowView(
                store: Store(
                    initialState: Row.State(
                        id: 1,
                        order: .descending,
                        dice: .blue
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
                    order: .descending,
                    dice: .blue
                ),
                reducer: Row.init
            )
        )
    }
}
