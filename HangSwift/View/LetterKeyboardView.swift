//
//  LetterKeyboardView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct LetterKeyboardView: View {

    let guessedLetters: Set<Character>
    let onTapLetter: (Character) -> Void

    private let letters = Array(
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    )

    private let columns = Array(
        repeating: GridItem(.flexible()),
        count: 7
    )

    var body: some View {

        LazyVGrid(
            columns: columns,
            spacing: 12
        ) {

            ForEach(
                letters,
                id: \.self
            ) { letter in

                Button {

                    onTapLetter(letter)

                } label: {

                    Text(String(letter))
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(
                            width: 42,
                            height: 42
                        )
                        .background(

                            guessedLetters.contains(letter)
                            ? Color.gray.opacity(0.4)
                            : Color.indigo
                        )
                        .clipShape(Circle())
                        .shadow(
                            color: .indigo.opacity(0.25),
                            radius: 6,
                            x: 0,
                            y: 4
                        )
                }
                .disabled(
                    guessedLetters.contains(letter)
                )
            }
        }
    }
}
