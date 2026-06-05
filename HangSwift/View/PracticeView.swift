//
//  SwiftUIView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 05/06/26.
//

import SwiftUI

struct PracticeView: View {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    private var viewModel: PracticeViewModel

    init(words: [HistoryItem]) {

        _viewModel =
            StateObject(
                wrappedValue:
                    PracticeViewModel(
                        words: words
                    )
            )
    }

    var body: some View {

        VStack(spacing: 24) {

            HStack {

                Button {

                    dismiss()

                } label: {

                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }

                Text("Treinar Palavras")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal)

            Spacer()

            if let word = viewModel.currentWord {

                Text("Traduza para inglês")
                    .font(.headline)
                    .foregroundStyle(.gray)

                Text(word.translatedWord)
                    .font(
                        .system(
                            size: 36,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)

                Text(viewModel.formattedAnswer)
                    .font(
                        .system(
                            size: 34,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.green)

                PracticeKeyboardView(

                    answer: viewModel.answer,

                    targetWord:
                        word.englishWord,

                    onTapLetter: {

                        viewModel.addLetter($0)
                    },

                    onDelete: {

                        viewModel.removeLastLetter()
                    }
                )

                Button {

                    viewModel.checkAnswer()

                } label: {

                    Text("Verificar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 16
                            )
                        )
                }

                if viewModel.showResult {

                    VStack(spacing: 12) {

                        Text(
                            viewModel.resultMessage
                        )
                        .foregroundStyle(.white)

                        Button {

                            viewModel.nextWord()

                        } label: {

                            Text("Próxima Palavra")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.green)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 16
                                    )
                                )
                        }
                    }
                }
            }

            Spacer()

            HStack {

                Label(
                    "\(viewModel.correctAnswers)",
                    systemImage:
                        "checkmark.circle.fill"
                )
                .foregroundStyle(.green)

                Spacer()

                Label(
                    "\(viewModel.wrongAnswers)",
                    systemImage:
                        "xmark.circle.fill"
                )
                .foregroundStyle(.red)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            Color.black.ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}
