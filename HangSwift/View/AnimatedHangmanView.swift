//
//  AnimatedHangmanView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 26/05/26.
//

import SwiftUI

struct AnimatedHangmanView: View {

    @State private var wrongAttempts = 0

    var body: some View {

        ZStack {

            HangmanDrawingView(
                wrongAttempts: wrongAttempts
            )
            .scaleEffect(0.45)
        }
        .frame(width: 120, height: 120)
        .clipped()
        .onAppear {

            Timer.scheduledTimer(
                withTimeInterval: 0.7,
                repeats: true
            ) { _ in

                withAnimation(
                    .easeInOut(duration: 0.3)
                ) {

                    if wrongAttempts < 6 {
                        wrongAttempts += 1
                    } else {
                        wrongAttempts = 0
                    }
                }
            }
        }
    }
}

#Preview {
    AnimatedHangmanView()
}
