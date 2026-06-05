//
//  SwiftUIView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 05/06/26.
//

import SwiftUI
import SwiftData

struct PracticeView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext

    @Query
    private var stats: [PracticeStats]

    @StateObject
    private var viewModel: PracticeViewModel

    init(words: [PlayedWord]) {

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

            // HEADER

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

                    let isCorrect =
                        viewModel.checkAnswer()

                    updateStats(
                        correct: isCorrect
                    )

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

            // ESTATÍSTICAS SALVAS

            if let stats = stats.first {

                VStack(spacing: 12) {

                    HStack {

                        Label(
                            "\(stats.correctAnswers)",
                            systemImage:
                                "checkmark.circle.fill"
                        )
                        .foregroundStyle(.green)

                        Spacer()

                        Label(
                            "\(stats.wrongAnswers)",
                            systemImage:
                                "xmark.circle.fill"
                        )
                        .foregroundStyle(.red)
                    }

                    let total =
                        stats.correctAnswers +
                        stats.wrongAnswers

                    if total > 0 {

                        let percentage =
                            Int(
                                (
                                    Double(
                                        stats.correctAnswers
                                    )
                                    /
                                    Double(total)
                                ) * 100
                            )

                        HStack {

                            Label(
                                "\(percentage)% de acerto",
                                systemImage:
                                    "chart.line.uptrend.xyaxis"
                            )
                            .font(.caption)

                            Spacer()
                        }
                        .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)

            } else {

                HStack {

                    Label(
                        "0",
                        systemImage:
                            "checkmark.circle.fill"
                    )
                    .foregroundStyle(.green)

                    Spacer()

                    Label(
                        "0",
                        systemImage:
                            "xmark.circle.fill"
                    )
                    .foregroundStyle(.red)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(
            Color.black.ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }

    private func updateStats(
        correct: Bool
    ) {

        let statsObject: PracticeStats

        if let existing = stats.first {

            statsObject = existing

        } else {

            let newStats =
                PracticeStats()

            modelContext.insert(
                newStats
            )

            statsObject = newStats
        }

        if correct {

            statsObject.correctAnswers += 1

        } else {

            statsObject.wrongAnswers += 1
        }
    }
}

#Preview {

    NavigationStack {

        PracticeView(
            words: []
        )
        .modelContainer(
            for: [
                PlayedWord.self,
                PracticeStats.self
            ]
        )
    }
}
