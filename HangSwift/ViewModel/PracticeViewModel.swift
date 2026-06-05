//
//  PracticeViewModel.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 05/06/26.
//

import Foundation

@MainActor
final class PracticeViewModel: ObservableObject {

    @Published var currentWord: PlayedWord?

    @Published var answer = ""

    @Published var resultMessage = ""

    @Published var showResult = false

    @Published var correctAnswers = 0

    @Published var wrongAnswers = 0

    private var words: [PlayedWord]

    init(words: [PlayedWord]) {

        self.words =
            words.shuffled()

        loadNextWord()
    }

    var formattedAnswer: String {

        guard let currentWord else {
            return ""
        }

        let word =
            currentWord.englishWord

        guard let firstLetter =
                word.first else {
            return ""
        }

        var display: [String] = [

            String(firstLetter)
        ]

        let typedLetters =
            Array(answer)

        for index in 1..<word.count {

            let answerIndex =
                index - 1

            if answerIndex
                < typedLetters.count {

                display.append(

                    String(
                        typedLetters[
                            answerIndex
                        ]
                    )
                )

            } else {

                display.append("_")
            }
        }

        return display.joined(
            separator: " "
        )
    }

    func addLetter(
        _ letter: String
    ) {

        guard let currentWord else {
            return
        }

        let maxLetters =
            currentWord
            .englishWord
            .count - 1

        guard answer.count
                < maxLetters else {
            return
        }

        answer += letter
    }

    func removeLastLetter() {

        guard !answer.isEmpty else {
            return
        }

        answer.removeLast()
    }

    @discardableResult
    func checkAnswer() -> Bool {

        guard let currentWord else {
            return false
        }

        let fullAnswer =

            String(
                currentWord
                    .englishWord
                    .prefix(1)
            ) + answer

        let isCorrect =

            fullAnswer
            .lowercased()

            ==

            currentWord
            .englishWord
            .lowercased()

        if isCorrect {

            correctAnswers += 1

            resultMessage =
                "✅ Correto!"

        } else {

            wrongAnswers += 1

            resultMessage =
                "❌ Correto: \(currentWord.englishWord)"
        }

        showResult = true

        return isCorrect
    }

    func nextWord() {

        answer = ""

        showResult = false

        loadNextWord()
    }

    private func loadNextWord() {

        currentWord =
            words.randomElement()
    }
}
