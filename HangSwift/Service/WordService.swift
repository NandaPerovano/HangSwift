//
//  Services:WordService.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import Foundation

struct DatamuseWord: Decodable {
    let word: String
}

final class WordAPIService {

    func fetchWord() async throws -> String {

        guard let url = URL(
            string: "https://api.datamuse.com/words?sp=?????"
        ) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let words = try JSONDecoder().decode(
            [DatamuseWord].self,
            from: data
        )

        let randomWord = words.randomElement()?.word ?? "SWIFT"

        return randomWord
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
    }
}
