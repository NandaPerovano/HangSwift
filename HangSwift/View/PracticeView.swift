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
        _viewModel = StateObject(
            wrappedValue: PracticeViewModel(
                words: words
            )
        )
    }

    // MARK: - Stats

    private var totalAttempts: Int {
        guard let stats = stats.first else {
            return 0
        }
        return stats.correctAnswers + stats.wrongAnswers
    }

    private var successRate: Int {
        guard let stats = stats.first else {
            return 0
        }

        let total = stats.correctAnswers + stats.wrongAnswers

        guard total > 0 else {
            return 0
        }

        return Int((Double(stats.correctAnswers) / Double(total)) * 100)
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
        VStack(spacing: 0) {
            
            // HEADER (Fixo no topo, fora do ScrollView)
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.white)
                }

                Text("Treinar Palavras")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // CONTEÚDO SCROLLÁVEL
            ScrollView {
                VStack(spacing: 24) {

                    // RANKING
                    VStack(spacing: 14) {
                        Text("🏆 Seu Desempenho")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("\(successRate)%")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(.green)

                        Text(ranking)
                            .font(.headline)
                            .foregroundStyle(.yellow)

                        Text("\(totalAttempts) tentativas")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // ÁREA DE TRADUÇÃO
                    if let word = viewModel.currentWord {
                        VStack(spacing: 16) {
                            Text("Traduza para inglês")
                                .font(.headline)
                                .foregroundStyle(.gray)

                            Text(word.translatedWord)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)

                            Text(viewModel.formattedAnswer)
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundStyle(.green)
                                .multilineTextAlignment(.center)
                        }

                        PracticeKeyboardView(
                            answer: viewModel.answer,
                            targetWord: word.englishWord,
                            onTapLetter: {
                                viewModel.addLetter($0)
                            },
                            onDelete: {
                                viewModel.removeLastLetter()
                            }
                        )

                        if viewModel.showResult {
                            Text(viewModel.resultMessage)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.top, 8)
                        }
                    }

                    // PONTUAÇÃO
                    HStack {
                        Label(
                            "\(stats.first?.correctAnswers ?? 0)",
                            systemImage: "checkmark.circle.fill"
                        )
                        .foregroundStyle(.green)

                        Spacer()

                        Label(
                            "\(stats.first?.wrongAnswers ?? 0)",
                            systemImage: "xmark.circle.fill"
                        )
                        .foregroundStyle(.red)
                    }
                }
                .padding()
            }

            Spacer() // Garante o empurrão do botão para a base da tela

            // BOTÃO FIXO EMBAIXO (Fora do ScrollView)
            VStack(spacing: 0) {
                if viewModel.showResult {
                    Button {
                        viewModel.nextWord()
                    } label: {
                        Text("Próxima Palavra")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.indigo, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .indigo.opacity(0.35), radius: 12, x: 0, y: 8)
                    }
                } else {
                    Button {
                        let isCorrect = viewModel.checkAnswer()
                        updateStats(correct: isCorrect)
                    } label: {
                        Text("Verificar")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.indigo, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .indigo.opacity(0.35), radius: 12, x: 0, y: 8)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
            .background(Color.black) // Fundo preto para cobrir o conteúdo que passa por baixo
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.black.ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }

    private func updateStats(correct: Bool) {
        let statsObject: PracticeStats

        if let existing = stats.first {
            statsObject = existing
        } else {
            let newStats = PracticeStats()
            modelContext.insert(newStats)
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
        PracticeView(words: [])
            .modelContainer(for: [PlayedWord.self, PracticeStats.self])
    }
}
