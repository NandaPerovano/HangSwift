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

    // MARK: - Geral Stats (Histórico Global)

    private var totalAttempts: Int {
        guard let stats = stats.first else { return 0 }
        return stats.correctAnswers + stats.wrongAnswers
    }

    private var successRate: Int {
        guard let stats = stats.first else { return 0 }
        let total = stats.correctAnswers + stats.wrongAnswers
        guard total > 0 else { return 0 }
        return Int((Double(stats.correctAnswers) / Double(total)) * 100)
    }

    private var ranking: String {
        switch successRate {
        case 90...: return "👑 Mestre das Palavras"
        case 75..<90: return "🏆 Especialista"
        case 60..<75: return "🚀 Aprendiz Avançado"
        case 40..<60: return "📚 Estudante"
        default: return "🌱 Iniciante"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            
            // HEADER (Totalmente fixo fora do scroll)
            VStack(spacing: 14) {
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
                    
                    // Elemento do Streak 🔥 dinâmico vindo do ViewModel
                    if viewModel.currentStreak > 0 {
                        HStack(spacing: 4) {
                            Text("🔥")
                            Text("\(viewModel.currentStreak)")
                                .font(.headline.bold())
                                .foregroundStyle(.orange)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.15))
                        .clipShape(Capsule())
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // BARRA DE PROGRESSO FLUIDA
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(LinearGradient(
                                colors: [.purple, .indigo],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: geo.size.width * CGFloat(viewModel.progressFraction), height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.progressFraction)
            }
            .padding(.bottom, 10)
            .background(Color.black)

            // CONTEÚDO SCROLLÁVEL
            ScrollView {
                VStack(spacing: 24) {

                    // CARD DE DESEMPENHO (Efeito Premium de Vidro Fosco)
                    VStack(spacing: 14) {
                        Text("🏆 Seu Desempenho Histórico")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white.opacity(0.6))

                        Text("\(successRate)%")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(.green)

                        Text(ranking)
                            .font(.headline)
                            .foregroundStyle(.yellow)

                        Text("\(totalAttempts) tentativas completadas")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial) // Efeito Blurring Glassmorphism nativo
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )

                    // CONTROLADOR DA ÁREA PRINCIPAL JOGO / FIM DO CIRCUITO
                    if let word = viewModel.currentWord {
                        
                        // ÁREA DE TRADUÇÃO ATIVA
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
                                .foregroundStyle(viewModel.showResult ? (viewModel.resultMessage.contains("✅") ? .green : .red) : .green)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 8)

                        // TECLADO CUSTOMIZADO
                        PracticeKeyboardView(
                            answer: viewModel.answer,
                            targetWord: word.englishWord,
                            onTapLetter: { letter in
                                viewModel.addLetter(letter)
                            },
                            onDelete: {
                                viewModel.removeLastLetter()
                            }
                        )

                        // MENSAGEM DE RESULTADO
                        if viewModel.showResult {
                            Text(viewModel.resultMessage)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .padding(.top, 4)
                                .transition(.opacity.combined(with: .slide))
                        }
                        
                    } else {
                        // TELA DE SESSÃO CONCLUÍDA (Quando acabam as palavras do array)
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.yellow)
                            
                            Text("Treino Concluído!")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            
                            Text("Você revisou todas as palavras selecionadas para esta rodada.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .padding(.top, 40)
                    }

                    // PLACAR DE ACERTOS DA SESSÃO ATUAL
                    HStack {
                        Label("\(viewModel.correctAnswers)", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Spacer()

                        Label("\(viewModel.wrongAnswers)", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                }
                .padding()
            }

            Spacer()

            // CONTEXTO DE BOTÃO FIXO (Permanente na base)
            VStack(spacing: 0) {
                if viewModel.isSessionFinished {
                    // Botão para sair caso tenha finalizado todas as palavras
                    Button {
                        dismiss()
                    } label: {
                        Text("Voltar para o Histórico")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                } else if viewModel.showResult {
                    Button {
                        withAnimation {
                            viewModel.nextWord()
                        }
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
            .background(Color.black)
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
