//
//  PlayedWord.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 05/06/26.
//

import Foundation
import SwiftData

@Model
final class PlayedWord {

    var englishWord: String
    var translatedWord: String
    var isCorrect: Bool
    var playedAt: Date

    init(
        englishWord: String,
        translatedWord: String,
        isCorrect: Bool
    ) {
        self.englishWord = englishWord
        self.translatedWord = translatedWord
        self.isCorrect = isCorrect
        self.playedAt = Date()
    }
}
