//
//  ContentView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var animateIcon = false

    var body: some View {

        NavigationStack {

            VStack(spacing: 32) {

                Spacer()
                      
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                    .scaleEffect(animateIcon ? 1.1 : 0.95)
                    .offset(y: animateIcon ? -8 : 8)
                    .shadow(
                        color: .blue.opacity(0.3),
                        radius: 12,
                        x: 0,
                        y: 8
                    )
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                    .onAppear {
                        animateIcon = true
                    }

                Text("Palavra Secreta")
                    .font(.system(size: 42, weight: .bold))

                Text("Descubra a palavra antes da forca ser completada.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                NavigationLink {

                    GameView()

                } label: {

                    Text("Jogar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 32)

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
