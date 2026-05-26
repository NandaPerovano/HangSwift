//
//  HangmanDrawingView.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI

struct HangmanDrawingView: View {

    let wrongAttempts: Int

    var body: some View {

        ZStack {

            // Base
            Path { path in
                path.move(to: CGPoint(x: 40, y: 180))
                path.addLine(to: CGPoint(x: 140, y: 180))
            }
            .stroke(Color.indigo, lineWidth: 4)

            // Poste vertical
            Path { path in
                path.move(to: CGPoint(x: 70, y: 180))
                path.addLine(to: CGPoint(x: 70, y: 40))
            }
            .stroke(Color.indigo, lineWidth: 4)

            // Topo
            Path { path in
                path.move(to: CGPoint(x: 70, y: 40))
                path.addLine(to: CGPoint(x: 120, y: 40))
            }
            .stroke(Color.indigo, lineWidth: 4)

            // Corda
            Path { path in
                path.move(to: CGPoint(x: 120, y: 40))
                path.addLine(to: CGPoint(x: 120, y: 60))
            }
            .stroke(Color.indigo, lineWidth: 4)

            // Cabeça
            if wrongAttempts >= 1 {

                Circle()
                    .stroke(
                        Color.indigo,
                        lineWidth: 4
                    )
                    .frame(width: 28, height: 28)
                    .position(x: 120, y: 75)
            }

            // Corpo
            if wrongAttempts >= 2 {

                Path { path in
                    path.move(to: CGPoint(x: 120, y: 89))
                    path.addLine(to: CGPoint(x: 120, y: 125))
                }
                .stroke(Color.indigo, lineWidth: 4)
            }

            // Braço esquerdo
            if wrongAttempts >= 3 {

                Path { path in
                    path.move(to: CGPoint(x: 120, y: 100))
                    path.addLine(to: CGPoint(x: 100, y: 115))
                }
                .stroke(Color.indigo, lineWidth: 4)
            }

            // Braço direito
            if wrongAttempts >= 4 {

                Path { path in
                    path.move(to: CGPoint(x: 120, y: 100))
                    path.addLine(to: CGPoint(x: 140, y: 115))
                }
                .stroke(Color.indigo, lineWidth: 4)
            }

            // Perna esquerda
            if wrongAttempts >= 5 {

                Path { path in
                    path.move(to: CGPoint(x: 120, y: 125))
                    path.addLine(to: CGPoint(x: 105, y: 150))
                }
                .stroke(Color.indigo, lineWidth: 4)
            }

            // Perna direita
            if wrongAttempts >= 6 {

                Path { path in
                    path.move(to: CGPoint(x: 120, y: 125))
                    path.addLine(to: CGPoint(x: 135, y: 150))
                }
                .stroke(Color.indigo, lineWidth: 4)
            }
        }
    }
}

#Preview {
    ZStack {

        Color.black
            .ignoresSafeArea()

        HangmanDrawingView(
            wrongAttempts: 6
        )
        .frame(width: 220, height: 220)
    }
}
