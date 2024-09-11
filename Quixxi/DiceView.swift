//
//  DiceView.swift
//  Quixxi
//
//  Created by Zac Johnson on 9/11/24.
//

import SwiftUI
import Pow

struct DiceView: View {
    @State private var isAnimating: Bool = false
    @State private var white: Int = 1
    @State private var red: Int = 2
    @State private var yellow: Int = 3
    @State private var green: Int = 4
    @State private var blue: Int = 5

    var showRed: Bool
    var showYellow: Bool
    var showGreen: Bool
    var showBlue: Bool

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "die.face.\(white)")
                        .resizable()
                        .scaledToFit()

                    if showRed {
                        Image(systemName: "die.face.\(red)")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.red)
                    }

                    if showYellow {
                        Image(systemName: "die.face.\(yellow)")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.yellow)
                    }

                    if showGreen {
                        Image(systemName: "die.face.\(green)")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.green)
                    }

                    if showBlue {
                        Image(systemName: "die.face.\(blue)")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                    }
                }
                .font(.title2)
                .changeEffect(.shake(rate: .fast), value: white)
            }
            .frame(height: 44)
        }
        .onShake {
            randomize()
        }
        .onTapGesture {
            randomize()
        }
    }

    private func randomize() {
        white = Int.random(in: 1...6)
        red = Int.random(in: 1...6)
        yellow = Int.random(in: 1...6)
        green = Int.random(in: 1...6)
        blue = Int.random(in: 1...6)
    }
}

#Preview {
    DiceView(
        showRed: true,
        showYellow: true,
        showGreen: true,
        showBlue: true
    )
}

// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
