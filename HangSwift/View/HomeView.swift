//
//  ContentView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct HomeView: View {

    var body: some View {

        NavigationStack {

            VStack(spacing: 20) {

                Spacer()

                AnimatedHangmanView()

                Text("Palavra Secreta")
                    .font(
                        .system(
                            size: 42,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)

                Text("Descubra palavras em inglês, aprenda traduções e desafie sua memória.")
                    .font(.headline)
                    .foregroundStyle(.gray)
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
                        .background(
                            LinearGradient(
                                colors: [
                                    .indigo,
                                    .purple
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 16
                            )
                        )
                        .shadow(
                            color: .indigo.opacity(0.35),
                            radius: 12,
                            x: 0,
                            y: 8
                        )
                }
                .padding(.horizontal, 32)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.black.ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
