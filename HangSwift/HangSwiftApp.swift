//
//  HangSwiftApp.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import SwiftUI
import SwiftData

@main
struct HangSwiftApp: App {

    var body: some Scene {

        WindowGroup {

            HomeView()
        }
        .modelContainer(
            for: PlayedWord.self
        )
    }
}
