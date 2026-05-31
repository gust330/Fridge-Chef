import Foundation

/// Serviço de Backend/IA integrado localmente (Serverless approach)
/// De acordo com o PRD, a app não tem um backend complexo,
/// comunicando diretamente com uma API de IA (ex: OpenAI, Anthropic, Gemini) 
/// para manter a app 'Local-First' sem custos mensais de servidores.
class AIRecipeService {
    static let shared = AIRecipeService()
    
    // NOTA: Para uso pessoal, o utilizador pode colocar aqui a sua própria API Key, 
    // ou podes usar a API da Apple (iOS 18+ Apple Intelligence) no futuro.
    private let apiKey = "COLOQUE_A_SUA_API_KEY_AQUI" 
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
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
        guard let url = URL(string: endpoint) else { throw AIError.invalidURL }
        
        let prompt = """
        Atuas como um chef profissional. 
        Tenho os seguintes ingredientes disponíveis em casa: \(availableIngredients.joined(separator: ", ")).
        Quero fazer uma refeição do tipo: \(mealType).
        A minha preferência alimentar é: \(dietPreference).
        
        Gera uma receita criativa usando o máximo possível dos meus ingredientes. Podes sugerir ingredientes extra muito básicos (sal, azeite).
        Responde ESTRITAMENTE num formato JSON válido com as seguintes chaves exatas:
        - "title" (String)
        - "mealType" (String)
        - "dietType" (String)
        - "prepTime" (Int, minutos)
        - "cookTime" (Int, minutos)
        - "difficulty" (String, ex: "Fácil", "Média")
        - "calories" (Int)
        - "ingredientsText" (String, lista formatada com bullet points)
        - "stepsText" (String, passos numerados)
        """
        
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini", // Modelo rápido e barato
            "messages": [
                ["role": "system", "content": "You are a helpful culinary assistant that outputs only valid JSON."],
                ["role": "user", "content": prompt]
            ],
            "response_format": ["type": "json_object"],
            "temperature": 0.7
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AIError.apiError("Erro de comunicação com a IA.")
        }
        
        // Fazer parsing da resposta do OpenAI
        struct OpenAIResponse: Codable {
            struct Choice: Codable {
                struct Message: Codable {
                    let content: String
                }
                let message: Message
            }
            let choices: [Choice]
        }
        
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let jsonString = openAIResponse.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw AIError.decodingError
        }
        
        // Fazer parsing do JSON gerado pela IA para a nossa estrutura
        let generatedAI = try JSONDecoder().decode(AIResponseFormat.self, from: jsonData)
        
        // Converter para o nosso modelo SwiftData (Recipe)
        let newRecipe = Recipe(
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
        
        return newRecipe
    }
}
