//
//  Views:GameView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct GameView: View {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    private var viewModel = HangmanViewModel()

    var body: some View {

        VStack(spacing: 24) {

            // HEADER
            HStack {

                Button {

                    dismiss()

                } label: {

                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.white)
                }

                Spacer()

                Text("Palavra Secreta")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer()

                Color.clear
                    .frame(width: 20)
            }
            .padding(.horizontal)

            Text(
                "Tentativas restantes: \(viewModel.remainingAttempts)"
            )
            .font(.headline)
            .foregroundStyle(.white)

            HangmanDrawingView(
                wrongAttempts: viewModel.wrongAttempts
            )
            .frame(height: 220)

            // PALAVRA
            Text(
                viewModel.isGameLost
                ? viewModel.game.word
                : viewModel.formattedWord
            )
            .font(
                .system(
                    size: 46,
                    weight: .heavy,
                    design: .rounded
                )
            )
            .tracking(8)
            .foregroundStyle(

                viewModel.isGameWon
                ? .green

                : viewModel.isGameLost
                ? .red

                : .white
            )
            .shadow(
                color:
                    viewModel.isGameWon
                    ? .green.opacity(0.7)

                    : viewModel.isGameLost
                    ? .red.opacity(0.7)

                    : .white.opacity(0.2),
                radius: 12
            )
            .scaleEffect(
                viewModel.isGameWon || viewModel.isGameLost
                ? 1.1
                : 1
            )
            .padding(.vertical, 24)
            .animation(
                .easeInOut,
                value: viewModel.isGameLost
            )

            LetterKeyboardView(
                guessedLetters: viewModel.game.guessedLetters,
                onTapLetter: { letter in

                    viewModel.guess(
                        letter: letter
                    )
                }
            )

            // TRADUÇÃO
            if viewModel.isGameWon || viewModel.isGameLost {

                VStack(spacing: 6) {

                    Text("TRADUÇÃO")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    Text(viewModel.translatedWord)
                        .font(
                            .system(
                                size: 28,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.white)
                }
                .padding(.top, 16)
                .transition(.opacity)
            }

            Spacer()
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(
            Color.black.ignoresSafeArea()
        )
        .navigationBarHidden(true)
        .alert(
            viewModel.resultTitle,
            isPresented: $viewModel.showResultAlert
        ) {

            Button("Jogar novamente") {

                viewModel.restartGame()
            }

            Button(
                "Cancelar",
                role: .cancel
            ) { }

        } message: {

            Text(
                viewModel.resultMessage
            )
        }
    }
}

#Preview {

    NavigationStack {

        GameView()
    }
}
