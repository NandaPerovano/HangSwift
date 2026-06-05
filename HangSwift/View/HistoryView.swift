//
//  HistoryView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 26/05/26.
//

import SwiftUI
import SwiftData

struct HistoryView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Query(
        sort: \PlayedWord.playedAt,
        order: .reverse
    )
    private var history: [PlayedWord]

    var body: some View {

        VStack(spacing: 0) {

            // HEADER (Ajustado o respiro e espaçamento)
            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.leading, 4) // Evita que fique colado na borda da tela
                }

                Text("Suas Palavras")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 16) // Um pouco mais de espaço abaixo da status bar
            .padding(.bottom, 12)

            // LISTA
            ScrollView {

                LazyVStack(
                    spacing: 16
                ) {

                    if history.isEmpty {

                        VStack(spacing: 12) {

                            Image(
                                systemName: "text.book.closed"
                            )
                            .font(
                                .system(size: 40)
                            )
                            .foregroundStyle(.gray)

                            Text(
                                "Nenhuma palavra jogada ainda"
                            )
                            .foregroundStyle(.gray)
                        }
                        .padding(.top, 60)

                    } else {

                        ForEach(history) { item in

                            HStack {

                                VStack(
                                    alignment: .leading,
                                    spacing: 6
                                ) {
                                    // 1. FORMATAÇÃO DE TEXTO: Transforma "AMENABLE" em "Amenable"
                                    Text(item.englishWord.capitalized)
                                        .font(.headline)
                                        .foregroundStyle(.white)

                                    // 2. FILTRO INTELIGENTE: Esconde o subtítulo se não houver tradução válida
                                    if !item.translatedWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                                        item.translatedWord.lowercased() != "sem tradução" {
                                        
                                        Text(item.translatedWord.capitalized)
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                }

                                Spacer()

                                // 3. ACESSIBILIDADE: Círculo indicador agora contém ícones visuais (visto em image_8cd3e4.png)
                                ZStack {
                                    Circle()
                                        .fill(item.isCorrect ? .green : .red)
                                        .frame(width: 20, height: 20)
                                    
                                    Image(systemName: item.isCorrect ? "checkmark" : "xmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding()
                            .background(
                                Color.white.opacity(0.04) // Leve aumento para destacar no fundo puramente preto
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16
                                )
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }

            // BOTÃO FIXO
            NavigationLink {

                PracticeView(
                    words: history
                )

            } label: {

                HStack {

                    Image(
                        systemName: "brain.head.profile"
                    )

                    Text("Treinar Palavras")
                        .fontWeight(.semibold)
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            .indigo,
                            .purple
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
                .shadow(
                    color: .indigo.opacity(0.35),
                    radius: 12,
                    x: 0,
                    y: 8
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(
                Color.black
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(
            Color.black.ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}

#Preview {

    NavigationStack {

        HistoryView()
            .modelContainer(
                for: PlayedWord.self
            )
    }
}
