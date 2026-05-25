//
//  Models:HangmanGame.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import Foundation

struct HangmanGame {
    let word: String
    var guessedLetters: Set<Character> = []
    var wrongAttempts: Int = 0
    let maxAttempts: Int = 6
}
