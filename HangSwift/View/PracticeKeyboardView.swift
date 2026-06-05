//
//  PracticeKeyboardView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 05/06/26.
//

import SwiftUI

struct PracticeKeyboardView: View {

    let answer: String
    let targetWord: String

    let onTapLetter: (String) -> Void
    let onDelete: () -> Void

    private let rows = [
        Array("ABCDEFGHIJ"),
        Array("KLMNOPQRST"),
        Array("UVWXYZ")
    ]

    var body: some View {

        VStack(spacing: 12) {

            ForEach(rows.indices, id: \.self) { rowIndex in

                HStack(spacing: 8) {

                    ForEach(rows[rowIndex], id: \.self) { letter in

                        Button {

                            guard answer.count < targetWord.count else {
                                return
                            }

                            onTapLetter(
                                String(letter)
                            )

                        } label: {

                            Text(String(letter))
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(
                                    width: 32,
                                    height: 44
                                )
                                .background(
                                    Color.indigo
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 8
                                    )
                                )
                        }
                    }
                }
            }

            Button {

                onDelete()

            } label: {

                Label(
                    "Apagar",
                    systemImage:
                        "delete.left.fill"
                )
                .foregroundStyle(.white)
            }
            .padding(.top, 8)
        }
    }
}
