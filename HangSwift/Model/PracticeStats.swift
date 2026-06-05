//
//  PracticeStats.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 05/06/26.
//

import Foundation
import SwiftData

@Model
final class PracticeStats {

    var correctAnswers: Int
    var wrongAnswers: Int

    init(
        correctAnswers: Int = 0,
        wrongAnswers: Int = 0
    ) {
        self.correctAnswers = correctAnswers
        self.wrongAnswers = wrongAnswers
    }
}
