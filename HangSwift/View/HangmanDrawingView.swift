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

            Path { path in

                path.move(to: CGPoint(x: 40, y: 200))
                path.addLine(to: CGPoint(x: 180, y: 200))

                path.move(to: CGPoint(x: 80, y: 200))
                path.addLine(to: CGPoint(x: 80, y: 20))

                path.move(to: CGPoint(x: 80, y: 20))
                path.addLine(to: CGPoint(x: 160, y: 20))

                path.move(to: CGPoint(x: 160, y: 20))
                path.addLine(to: CGPoint(x: 160, y: 50))
            }
            .stroke(lineWidth: 4)

            if wrongAttempts >= 1 {

                Circle()
                    .stroke(lineWidth: 4)
                    .frame(width: 40, height: 40)
                    .position(x: 160, y: 70)
            }

            if wrongAttempts >= 2 {

                Path { path in
                    path.move(to: CGPoint(x: 160, y: 90))
                    path.addLine(to: CGPoint(x: 160, y: 140))
                }
                .stroke(lineWidth: 4)
            }

            if wrongAttempts >= 3 {

                Path { path in
                    path.move(to: CGPoint(x: 160, y: 105))
                    path.addLine(to: CGPoint(x: 130, y: 125))
                }
                .stroke(lineWidth: 4)
            }

            if wrongAttempts >= 4 {

                Path { path in
                    path.move(to: CGPoint(x: 160, y: 105))
                    path.addLine(to: CGPoint(x: 190, y: 125))
                }
                .stroke(lineWidth: 4)
            }

            if wrongAttempts >= 5 {

                Path { path in
                    path.move(to: CGPoint(x: 160, y: 140))
                    path.addLine(to: CGPoint(x: 135, y: 175))
                }
                .stroke(lineWidth: 4)
            }

            if wrongAttempts >= 6 {

                Path { path in
                    path.move(to: CGPoint(x: 160, y: 140))
                    path.addLine(to: CGPoint(x: 185, y: 175))
                }
                .stroke(lineWidth: 4)
            }
        }
    }
}
