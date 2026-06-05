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
    
    // Contadores da sessão atual
    @Published var correctAnswers = 0
    @Published var wrongAnswers = 0
    @Published var currentStreak = 0 // Nova propriedade para controlar o foguinho 🔥

    private var words: [PlayedWord]
    private var currentIndex = 0 // Controla a posição atual na sequência

    init(words: [PlayedWord]) {
        // Embaralha a lista uma única vez para criar um circuito único de treino
        self.words = words.shuffled()
        loadNextWord()
    }

    // Retorna o progresso atual formatado em double (ex: 0.2, 0.5, 1.0) para a barra
    var progressFraction: Double {
        guard !words.isEmpty else { return 0 }
        return Double(currentIndex) / Double(words.count)
    }

    var isSessionFinished: Bool {
        return words.isEmpty || (currentIndex >= words.count && !showResult)
    }

    var formattedAnswer: String {
        guard let currentWord else { return "" }

        let word = currentWord.englishWord
        guard let firstLetter = word.first else { return "" }

        var display: [String] = [String(firstLetter)]
        let typedLetters = Array(answer)

        for index in 1..<word.count {
            let answerIndex = index - 1

            if answerIndex < typedLetters.count {
                display.append(String(typedLetters[answerIndex]))
            } else {
                display.append("_")
            }
        }

        return display.joined(separator: " ")
    }

    func addLetter(_ letter: String) {
        guard let currentWord else { return }

        let maxLetters = currentWord.englishWord.count - 1
        guard answer.count < maxLetters else { return }

        answer += letter
    }

    func removeLastLetter() {
        guard !answer.isEmpty else { return }
        answer.removeLast()
    }

    @discardableResult
    func checkAnswer() -> Bool {
        guard let currentWord else { return false }

        let fullAnswer = String(currentWord.englishWord.prefix(1)) + answer
        let isCorrect = fullAnswer.lowercased() == currentWord.englishWord.lowercased()

        if isCorrect {
            correctAnswers += 1
            currentStreak += 1 // Aumenta o combo de acertos 🔥
            resultMessage = "✅ Correto!"
        } else {
            wrongAnswers += 1
            currentStreak = 0 // Quebrou o streak, zera o foguinho!
            resultMessage = "❌ Correto: \(currentWord.englishWord)"
        }

        showResult = true
        return isCorrect
    }

    func nextWord() {
        answer = ""
        showResult = false
        
        // Avança para o próximo índice na sequência embaralhada
        currentIndex += 1
        loadNextWord()
    }

    private func loadNextWord() {
        // Verifica se ainda existem palavras no circuito
        if currentIndex < words.count {
            currentWord = words[currentIndex]
        } else {
            currentWord = nil // Fim das palavras enviadas para treino
        }
    }
}
