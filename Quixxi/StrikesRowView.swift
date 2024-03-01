//
//  StrikesRowView.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/29/24.
//

import ComposableArchitecture
import SwiftUI

struct StrikesRowView: View {
    let store: StoreOf<StrikesRow>
    var body: some View {
        HStack {
            ForEach(0...3, id: \.self) { index in
                Button {
                    store.send(.boxTapped(index), animation: .bouncy(extraBounce: 0.05))
                } label: {
                    Image(systemName: store.boxes[index].isNormal ? "square" : "x.square.fill")
                        .resizable()
                        .scaledToFit()
                }
                .foregroundStyle(.secondary)
            }
            
            ZStack {
                Image(systemName: "dice")
                Image(systemName: "nosign")
                    .font(.title)
                    .foregroundStyle(.red)
                
            }
        }
    }
}

#Preview {
    StrikesRowView(
        store: Store(
            initialState: StrikesRow.State(),
            reducer: StrikesRow.init
        )
    )
    .frame(height: 44)
}
