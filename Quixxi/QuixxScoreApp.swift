//
//  QuixxiApp.swift
//  Quixxi
//
//  Created by Zac Johnson on 2/26/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct QuixxScoreApp: App {

    var body: some Scene {
        WindowGroup {
            GameView(
                store: Store(
                    initialState: Game.State(),
                    reducer: Game.init
                )
            )
        }
    }
}
