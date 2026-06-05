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

    // MARK: - Statistics

    private var totalAttempts: Int {

        guard let stats = stats.first else {
            return 0
        }

        return
            stats.correctAnswers +
            stats.wrongAnswers
    }

    private var successRate: Int {

        guard let stats = stats.first else {
            return 0
        }

        let total =
            stats.correctAnswers +
            stats.wrongAnswers

        guard total > 0 else {
            return 0
        }

        return Int(
            (
                Double(stats.correctAnswers)
                /
                Double(total)
            ) * 100
        )
    }

    private var ranking: String {

        switch successRate {

        case 90...:
            return "👑 Mestre das Palavras"

        case 75..<90:
            return "🏆 Especialista"

        case 60..<75:
            return "🚀 Aprendiz Avançado"

        case 40..<60:
            return "📚 Estudante"

        default:
            return "🌱 Iniciante"
        }
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                // HEADER

                HStack {

                    Button {

                        dismiss()

                    } label: {

                        Image(
                            systemName: "chevron.left"
                        )
                        .foregroundStyle(.white)
                    }

                    Text("Treinar Palavras")
                        .font(.title3.bold())
                        .foregroundStyle(.white)

                    Spacer()
                }
                .padding(.horizontal)

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

                    Text(
                        viewModel.formattedAnswer
                    )
                    .font(
                        .system(
                            size: 34,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.green)
                    .multilineTextAlignment(.center)

                    PracticeKeyboardView(

                        answer:
                            viewModel.answer,

                        targetWord:
                            word.englishWord,

                        onTapLetter: {

                            viewModel.addLetter(
                                $0
                            )
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
                            .frame(
                                maxWidth: .infinity
                            )
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

                                Text(
                                    "Próxima Palavra"
                                )
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(
                                    maxWidth: .infinity
                                )
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

                Divider()
                    .overlay(.gray.opacity(0.3))
                    .padding(.vertical)

                // CONTADORES

                if let stats = stats.first {

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

                // CARD DE DESEMPENHO

                VStack(spacing: 14) {

                    Text("🏆 Seu Desempenho")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("\(successRate)%")
                        .font(
                            .system(
                                size: 48,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.green)

                    Text("Taxa de acerto")
                        .foregroundStyle(.gray)

                    Divider()
                        .overlay(
                            .gray.opacity(0.3)
                        )

                    Text(ranking)
                        .font(.title3.bold())
                        .foregroundStyle(.yellow)

                    Text(
                        "\(totalAttempts) tentativas realizadas"
                    )
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Color.white.opacity(0.05)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                )
                .padding(.horizontal)
            }
            .padding()
        }
        .background(
            Color.black.ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }

    // MARK: - Persistence

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
