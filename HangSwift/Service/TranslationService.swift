//
//  TranslationService.swift
//  HangSwift
//
//  Created by Fernanda Perovano on 26/05/26.
//

import Foundation

struct TranslationResponse: Decodable {

    struct ResponseData: Decodable {
        let translatedText: String
    }

    let responseData: ResponseData
}

final class TranslationService {

    func translate(word: String) async throws -> String {

        let encodedWord =
            word.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) ?? word

        guard let url = URL(
            string:
            "https://api.mymemory.translated.net/get?q=\(encodedWord)&langpair=en|pt-BR"
        ) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(
            TranslationResponse.self,
            from: data
        )

        let translated =
            decoded.responseData.translatedText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        // evita traduções iguais
        if translated.lowercased() ==
            word.lowercased() {

            return "Sem tradução"
        }

        // evita traduções muito estranhas/vazias
        if translated.isEmpty {

            return "Sem tradução"
        }

        return translated.uppercased()
    }
}
