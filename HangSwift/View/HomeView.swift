//
//  ContentView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct HomeView: View {

    @State private var animateIcon = false

    var body: some View {

        NavigationStack {

            VStack(spacing: 32) {

                Spacer()

                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.indigo)
                    .scaleEffect(animateIcon ? 1.1 : 0.95)
                    .offset(y: animateIcon ? -8 : 8)
                    .shadow(
                        color: .indigo.opacity(0.3),
                        radius: 12,
                        x: 0,
                        y: 8
                    )
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                    .onAppear {
                        animateIcon = true
                    }

                Text("Palavra Secreta")
                    .font(.system(size: 42, weight: .bold))

                Text("Descubra a palavra antes da forca ser completada.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                NavigationLink {

                    GameView()

                } label: {

                    Text("Jogar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: .indigo.opacity(0.25),
                            radius: 10,
                            x: 0,
                            y: 6
                        )
                }
                .padding(.horizontal, 32)

                Spacer()
            }
            .padding()
            .background(
                Color(.systemGroupedBackground)
            )
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
