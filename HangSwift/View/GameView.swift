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

                // balanceamento visual
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

            Text(
                viewModel.isGameLost
                ? viewModel.game.word
                : viewModel.formattedWord
            )
            .font(
                .system(
                    size: 36,
                    weight: .bold,
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

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
