//
//  ViewModels:HangmanViewModel.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import Foundation

@MainActor
final class HangmanViewModel: ObservableObject {

    // MARK: - Published

    @Published private(set) var game: HangmanGame
    @Published var showResultAlert = false
    @Published var translatedWord = ""

    // MARK: - Properties

    private let wordService = WordAPIService()

    private let translationService =
        TranslationService()

    // MARK: - Init

    init() {

        self.game = HangmanGame(word: "SWIFT")

        Task {
            await loadNewWord()
        }
    }

    // MARK: - Computed Properties

    var formattedWord: String {

        game.word.map { letter in

            game.guessedLetters.contains(letter)
            ? String(letter)
            : "_"

        }
        .joined(separator: " ")
    }

    var wrongAttempts: Int {
        game.wrongAttempts
    }

    var remainingAttempts: Int {
        game.maxAttempts - game.wrongAttempts
    }

    var isGameWon: Bool {

        game.word.allSatisfy {
            game.guessedLetters.contains($0)
        }
    }

    var isGameLost: Bool {
        game.wrongAttempts >= game.maxAttempts
    }

    var resultTitle: String {
        isGameWon
        ? "Você venceu!"
        : "Você perdeu!"
    }

    var resultMessage: String {

        isGameWon
        ? "Parabéns! Você acertou a palavra."
        : "A palavra era \(game.word)"
    }

    // MARK: - Actions

    func guess(letter: Character) {

        guard !game.guessedLetters.contains(letter),
              !isGameWon,
              !isGameLost else {
            return
        }

        game.guessedLetters.insert(letter)

        if !game.word.contains(letter) {
            game.wrongAttempts += 1
        }

        if isGameWon || isGameLost {

            Task {

                try? await Task.sleep(
                    nanoseconds: 800_000_000
                )

                showResultAlert = true
            }
        }
    }

    func restartGame() {

        showResultAlert = false

        Task {
            await loadNewWord()
        }
    }

    // MARK: - Private

    private func loadNewWord() async {

        do {

            let fetchedWord =
                try await wordService.fetchWord()

            self.game = HangmanGame(
                word: fetchedWord
            )

            self.translatedWord =
                try await translationService.translate(
                    word: fetchedWord
                )

        } catch {

            print(
                "Erro ao buscar palavra:",
                error
            )

            self.game = HangmanGame(
                word: "SWIFT"
            )

            self.translatedWord = "SWIFT"
        }
    }
}
