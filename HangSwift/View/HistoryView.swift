//
//  HistoryView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 26/05/26.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    let history: [HistoryItem]
    
    var body: some View {
        
        VStack(spacing: 16) {
            
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
            
            // CONTENT
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
                            .font(.system(size: 40))
                            .foregroundStyle(.gray)
                            
                            Text(
                                "Nenhuma palavra jogada ainda"
                            )
                            .foregroundStyle(.gray)
                        }
                        .padding(.top, 40)
                        
                    } else {
                        
                        ForEach(history) { item in
                            
                            HStack {
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 6
                                ) {
                                    
                                    Text(item.englishWord)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                    Text(item.translatedWord)
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
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .padding(.top)
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
        
        HistoryView(
            history: [
                HistoryItem(
                    englishWord: "ALIENATION",
                    translatedWord: "ALIENAÇÃO",
                    isCorrect: false
                )
            ]
        )
    }
}
