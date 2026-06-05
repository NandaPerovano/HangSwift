//
//  Views:GameView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI
import SwiftData

struct GameView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext

    @StateObject
    private var viewModel = HangmanViewModel()

    @State
    private var hasSavedWord = false

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

                HStack(spacing: 20) {

                    NavigationLink {

                        HistoryView()

                    } label: {

                        HStack(spacing: 6) {

                            Image(
                                systemName:
                                    "list.bullet.rectangle.portrait"
                            )

                            Text("Suas Palavras")
                                .font(.subheadline.bold())
                        }
                        .foregroundStyle(.white)
                    }

                    Button {

                        hasSavedWord = false
                        viewModel.restartGame()

                    } label: {

                        Image(systemName: "arrow.clockwise")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
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
                    size: 42,
                    weight: .heavy,
                    design: .rounded
                )
            )
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .minimumScaleFactor(0.55)
            .allowsTightening(true)
            .padding(.horizontal, 24)
            .tracking(
                viewModel.game.word.count > 8
                ? 4
                : 8
            )
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

            LetterKeyboardView(
                guessedLetters: viewModel.game.guessedLetters,
                onTapLetter: { letter in

                    viewModel.guess(
                        letter: letter
                    )

                    saveWordIfNeeded()
                }
            )

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

                hasSavedWord = false
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

    private func saveWordIfNeeded() {

        guard
            !hasSavedWord,
            viewModel.isGameWon || viewModel.isGameLost
        else {
            return
        }

        let playedWord = PlayedWord(
            englishWord: viewModel.game.word,
            translatedWord: viewModel.translatedWord,
            isCorrect: viewModel.isGameWon
        )

        modelContext.insert(
            playedWord
        )

        hasSavedWord = true
    }
}

#Preview {

    NavigationStack {

        GameView()
            .modelContainer(
                for: PlayedWord.self
            )
    }
}
