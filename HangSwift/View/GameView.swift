//
//  Views:GameView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI
import SwiftData

struct GameView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext

    @StateObject
    private var viewModel = HangmanViewModel()

    @State
    private var hasSavedWord = false

    var body: some View {
        VStack(spacing: 0) {

            // HEADER (Navegação limpa)
            HStack(alignment: .center) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Voltar")
                    }
                    .font(.body.bold())
                    .foregroundStyle(.white)
                }

                Spacer()

                HStack(spacing: 16) {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.plaintext")
                            Text("Palavras")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.white.opacity(0.8))
                    }

                    Button {
                        hasSavedWord = false
                        viewModel.restartGame()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.body.bold())
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // INDICADOR DE VIDAS (Corações dinâmicos)
            HStack(spacing: 6) {
                ForEach(0..<viewModel.game.maxAttempts, id: \.self) { index in
                    Image(systemName: index < viewModel.remainingAttempts ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(index < viewModel.remainingAttempts ? .red : .white.opacity(0.15))
                        .scaleEffect(index < viewModel.remainingAttempts ? 1.0 : 0.85)
                        .animation(.easeOut(duration: 0.2), value: viewModel.remainingAttempts)
                }
            }
            .padding(.vertical, 4)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // ÁREA DA FORCA
                    HangmanDrawingView(
                        wrongAttempts: viewModel.wrongAttempts
                    )
                    .frame(height: 170)
                    .padding(.top, 4)

                    // TRADUÇÃO REVELADA APENAS NO FIM DO JOGO (Com animação suave)
                    if viewModel.isGameWon || viewModel.isGameLost {
                        VStack(spacing: 4) {
                            Text("TRADUÇÃO")
                                .font(.system(.caption, design: .rounded))
                                .bold()
                                .tracking(2.0)
                                .foregroundStyle(viewModel.isGameWon ? .green : .red)
                            
                            Text(viewModel.translatedWord.isEmpty ? "Carregando..." : viewModel.translatedWord.capitalized)
                                .font(.system(.title3, design: .rounded))
                                .bold()
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            (viewModel.isGameWon ? Color.green : Color.red)
                                .opacity(0.1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        // Spacer invisível para manter a estrutura e o teclado na mesma posição durante o jogo
                        Color.clear
                            .frame(height: 64)
                            .padding(.horizontal)
                    }

                    // PALAVRA SECRETA / TRAÇOS
                    Text(
                        viewModel.isGameLost
                        ? viewModel.game.word
                        : viewModel.formattedWord
                    )
                    .font(
                        .system(
                            size: viewModel.game.word.count > 8 ? 34 : 42,
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 24)
                    .tracking(viewModel.game.word.count > 8 ? 4 : 8)
                    .foregroundStyle(
                        viewModel.isGameWon ? .green :
                        viewModel.isGameLost ? .red : .white
                    )
                    .shadow(
                        color:
                            viewModel.isGameWon ? .green.opacity(0.4) :
                            viewModel.isGameLost ? .red.opacity(0.4) : .white.opacity(0.05),
                        radius: 8
                    )
                    .animation(.spring(), value: viewModel.isGameWon || viewModel.isGameLost)

                    // TECLADO CUSTOMIZADO
                    LetterKeyboardView(
                        guessedLetters: viewModel.game.guessedLetters,
                        secretWord: viewModel.game.word,
                        onTapLetter: { letter in
                            // Adiciona animação nativa ao pressionar e revelar os estados
                            withAnimation(.easeInOut) {
                                viewModel.guess(letter: letter)
                            }
                            saveWordIfNeeded()
                        }
                    )
                }
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
        .alert(
            viewModel.resultTitle,
            isPresented: $viewModel.showResultAlert
        ) {
            Button("Jogar novamente") {
                hasSavedWord = false
                viewModel.restartGame()
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text(viewModel.resultMessage)
        }
    }

    private func saveWordIfNeeded() {
        guard !hasSavedWord, viewModel.isGameWon || viewModel.isGameLost else { return }

        let translation = viewModel.translatedWord.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalTranslation = translation.isEmpty ? viewModel.game.word : translation

        let playedWord = PlayedWord(
            englishWord: viewModel.game.word,
            translatedWord: finalTranslation,
            isCorrect: viewModel.isGameWon
        )

        modelContext.insert(playedWord)
        hasSavedWord = true
    }
}
