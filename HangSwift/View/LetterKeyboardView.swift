//
//  LetterKeyboardView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct LetterKeyboardView: View {
    let guessedLetters: Set<Character>
    let secretWord: String
    let onTapLetter: (Character) -> Void

    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    private let columns = Array(
        repeating: GridItem(.flexible()),
        count: 7
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(letters, id: \.self) { letter in
                
                let hasGuessed = guessedLetters.contains(letter)
                let isCorrect = hasGuessed && secretWord.contains(letter)
                let isWrong = hasGuessed && !secretWord.contains(letter)
                
                Button {
                    onTapLetter(letter)
                } label: {
                    Text(String(letter))
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            isCorrect ? Color.green :
                            isWrong ? Color.white.opacity(0.08) :
                            Color.indigo
                        )
                        .clipShape(Circle())
                        .opacity(isWrong ? 0.3 : 1.0) // Corrigido!
                        .shadow(
                            color: hasGuessed ? .clear : .indigo.opacity(0.3),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                }
                .disabled(hasGuessed)
            }
        }
        .padding(.horizontal)
    }
}
