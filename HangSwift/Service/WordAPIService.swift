//
//  Services:WordService.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 24/05/26.
//

import Foundation

struct WordResponse: Decodable {
    let word: String
}

final class WordAPIService {

    func fetchWord() async throws -> String {

        let length = Int.random(in: 5...10)

        let pattern = String(
            repeating: "?",
            count: length
        )

        guard let url = URL(
            string:
            "https://api.datamuse.com/words?sp=\(pattern)"
        ) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let words = try JSONDecoder().decode(
            [WordResponse].self,
            from: data
        )

        guard let randomWord =
                words.randomElement()?.word else {
            return "SWIFT"
        }

        return randomWord
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .uppercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
