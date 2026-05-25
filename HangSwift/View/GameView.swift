//
//  Views:GameView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = HangmanViewModel()

    var body: some View {

        VStack(spacing: 24) {

            Text("Tentativas restantes: \(viewModel.remainingAttempts)")
                .font(.headline)

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
                viewModel.isGameLost
                ? .red
                : .primary
            )
            .scaleEffect(viewModel.isGameLost ? 1.1 : 1)
            .padding(.vertical, 24)
            .animation(
                .easeInOut,
                value: viewModel.isGameLost
            )

            LetterKeyboardView(
                guessedLetters: viewModel.game.guessedLetters,
                onTapLetter: { letter in
                    viewModel.guess(letter: letter)
                }
            )

            Spacer()
        }
        .padding()
        .background(
            Color(.systemGroupedBackground)
        )
        .navigationTitle("Palavra Secreta")
        .navigationBarBackButtonHidden(true)
        .toolbar {

            ToolbarItem(placement: .topBarLeading) {

                Button {

                    dismiss()

                } label: {

                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.indigo)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            viewModel.resultTitle,
            isPresented: $viewModel.showResultAlert
        ) {

            Button("Jogar novamente") {
                viewModel.restartGame()
            }

            Button("Cancelar", role: .cancel) { }

        } message: {

            Text(viewModel.resultMessage)
        }
    }
}

#Preview {
    GameView()
}
