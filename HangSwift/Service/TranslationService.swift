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

        let (data, _) =
            try await URLSession.shared.data(
                from: url
            )

        let decoded =
            try JSONDecoder().decode(
                TranslationResponse.self,
                from: data
            )

        var translated =
            decoded.responseData.translatedText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        // remove tags HTML/XML
        translated =
            translated.replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression
            )

        // remove entidades HTML
        translated =
            translated.replacingOccurrences(
                of: "&quot;",
                with: "\""
            )

        translated =
            translated.replacingOccurrences(
                of: "&amp;",
                with: "&"
            )

        // remove conteúdo entre parênteses
        if let parenthesisIndex =
            translated.firstIndex(of: "(") {

            translated =
                String(
                    translated[..<parenthesisIndex]
                )
        }

        // remove pontuação
        translated =
            translated.trimmingCharacters(
                in: CharacterSet.punctuationCharacters
            )

        // remove espaços extras
        translated =
            translated.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        // evita tradução igual
        if translated.lowercased() ==
            word.lowercased() {

            return "Sem tradução"
        }

        // evita vazio
        if translated.isEmpty {

            return "Sem tradução"
        }

        return translated.uppercased()
    }
}
