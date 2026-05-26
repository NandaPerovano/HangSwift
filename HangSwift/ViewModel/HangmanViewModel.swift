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
    @Published var history: [HistoryItem] = []

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

    var formattedResultWord: String {

        let word = game.word

        guard word.count > 8 else {
            return word
        }

        let middleIndex =
            word.index(
                word.startIndex,
                offsetBy: word.count / 2
            )

        let firstPart =
            String(word[..<middleIndex])

        let secondPart =
            String(word[middleIndex...])

        return "\(firstPart)\n\(secondPart)"
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

            saveHistory()

            Task {

                try? await Task.sleep(
                    nanoseconds: 1_000_000_000
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

    private func saveHistory() {

        let item = HistoryItem(
            englishWord: game.word,
            translatedWord: translatedWord,
            isCorrect: isGameWon
        )

        history.insert(item, at: 0)
    }

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
