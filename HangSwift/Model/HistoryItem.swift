//
//  HistoryItem.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 26/05/26.
//

import Foundation

struct HistoryItem: Identifiable {

    let id = UUID()

    let englishWord: String
    let translatedWord: String
    let isCorrect: Bool
}
