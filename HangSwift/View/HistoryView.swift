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

            // HEADER

            HStack {

                Button {

                    dismiss()

                } label: {

                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.white)
                }

                Text("Suas Palavras")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // LISTA

            ScrollView {

                LazyVStack(
                    spacing: 16
                ) {

                    if history.isEmpty {

                        VStack(spacing: 12) {

                            Image(
                                systemName:
                                    "text.book.closed"
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

                                    Text(
                                        item.englishWord
                                    )
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                    Text(
                                        item.translatedWord
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                }

                                Spacer()

                                Circle()
                                    .fill(
                                        item.isCorrect
                                        ? .green
                                        : .red
                                    )
                                    .frame(
                                        width: 14,
                                        height: 14
                                    )
                            }
                            .padding()
                            .background(
                                Color.white.opacity(0.03)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16
                                )
                            )
                        }
                    }
                }
                .padding()
            }

            // BOTÃO FIXO

            NavigationLink {

                PracticeView(
                    words: history
                )

            } label: {

                HStack {

                    Image(
                        systemName:
                            "brain.head.profile"
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
                    color:
                        .indigo.opacity(0.35),
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
