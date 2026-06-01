import Foundation

/// Serviço de IA gratuito usando Google Gemini Flash.
/// Tier gratuito: 15 RPM, 1500 RPD. Sem custos.
/// Para uso pessoal, o utilizador coloca aqui a sua API key obtida em:
/// https://aistudio.google.com/app/apikey
class AIRecipeService {
    static let shared = AIRecipeService()

    private let apiKey = "COLOQUE_A_SUA_API_KEY_AQUI"
    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

    struct AIResponseFormat: Codable {
        let title: String
        let mealType: String
        let dietType: String
        let prepTime: Int
        let cookTime: Int
        let difficulty: String
        let calories: Int
        let ingredientsText: String
        let stepsText: String
    }

    enum AIError: Error {
        case invalidURL
        case noData
        case decodingError
        case apiError(String)
    }

    func generateRecipe(availableIngredients: [String], dietPreference: String, mealType: String) async throws -> Recipe {
        guard !apiKey.contains("AQUI") else {
            // Sem chave configurada, devolve receita local mock
            return mockRecipe(ingredients: availableIngredients, diet: dietPreference, mealType: mealType)
        }

        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else { throw AIError.invalidURL }

        let prompt = """
        Atua como um chef profissional. 
        Tenho estes ingredientes: \(availableIngredients.joined(separator: ", ")).
        Refeição: \(mealType). Dieta: \(dietPreference).
        Cria uma receita criativa usando o máximo possível dos ingredientes. Podes sugerir básicos (sal, azeite).
        Responde APENAS com JSON válido com estas chaves exatas:
        - "title" (String)
        - "mealType" (String)
        - "dietType" (String)
        - "prepTime" (Int, minutos)
        - "cookTime" (Int, minutos)
        - "difficulty" (String: "Fácil", "Média" ou "Difícil")
        - "calories" (Int)
        - "ingredientsText" (String, lista com bullet points)
        - "stepsText" (String, passos numerados)
        """

        let parameters: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ],
            "generationConfig": [
                "response_mime_type": "application/json",
                "temperature": 0.7
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let err = String(data: data, encoding: .utf8) ?? "sem detalhes"
            throw AIError.apiError("Erro Gemini: \(err)")
        }

        // Parse resposta do Gemini
        struct GeminiResponse: Codable {
            struct Candidate: Codable {
                struct Content: Codable {
                    struct Part: Codable {
                        let text: String
                    }
                    let parts: [Part]
                }
                let content: Content
            }
            let candidates: [Candidate]
        }

        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        guard let jsonString = geminiResponse.candidates.first?.content.parts.first?.text,
              let jsonData = jsonString.data(using: .utf8) else {
            throw AIError.decodingError
        }

        let generatedAI = try JSONDecoder().decode(AIResponseFormat.self, from: jsonData)

        return Recipe(
            title: generatedAI.title,
            mealType: generatedAI.mealType,
            dietType: generatedAI.dietType,
            prepTime: generatedAI.prepTime,
            cookTime: generatedAI.cookTime,
            difficulty: generatedAI.difficulty,
            ingredientsText: generatedAI.ingredientsText,
            stepsText: generatedAI.stepsText,
            calories: generatedAI.calories,
            isFavorite: false
        )
    }

    /// Receita de fallback quando não há API key configurada
    private func mockRecipe(ingredients: [String], diet: String, mealType: String) -> Recipe {
        let title = "Receita com \(ingredients.prefix(2).joined(separator: " e "))"
        return Recipe(
            title: title,
            mealType: mealType,
            dietType: diet,
            prepTime: 10,
            cookTime: 15,
            difficulty: "Fácil",
            ingredientsText: ingredients.enumerated().map { "• \($0.element)" }.joined(separator: "\n"),
            stepsText: "1. Reúne todos os ingredientes.\n2. Prepara e corta.\n3. Cozinha a gosto.\n4. Serve e bom apetite!",
            calories: 400,
            isFavorite: false
        )
    }
}
