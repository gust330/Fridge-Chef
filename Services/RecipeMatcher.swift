import Foundation
import SwiftData

/// Motor local de matching de receitas (PRD - Secção 2.4 e 2.5)
/// Pontua cada receita com base em:
/// - % de ingredientes disponíveis
/// - boost para ingredientes a expirar
/// - preferência alimentar
/// - tempo de preparação
final class RecipeMatcher {

    static func rank(
        recipes: [Recipe],
        ingredients: [Ingredient],
        preferredDiets: [String] = [],
        limit: Int = 20
    ) -> [RecipeMatch] {
        let available = ingredients.filter { $0.status != AppConstants.Status.outOfStock }
        let availableNames = Set(available.map { $0.normalizedName })

        let expiringSoon: Set<String> = {
            let now = Date()
            let in3Days = now.addingTimeInterval(60 * 60 * 24 * 3)
            return Set(
                available
                    .filter { ($0.expiryDate ?? .distantFuture) <= in3Days }
                    .map { $0.normalizedName }
            )
        }()

        let matches: [RecipeMatch] = recipes.map { recipe in
            let required = parseIngredients(recipe.ingredientsText)
            let requiredNames = required.map { $0.lowercased() }
            let present = requiredNames.filter { name in availableNames.contains(where: { $0.contains(name) || name.contains($0) }) }
            let missing = requiredNames.filter { name in !availableNames.contains(where: { $0.contains(name) || name.contains($0) }) }
            let percent = requiredNames.isEmpty ? 0 : (Double(present.count) / Double(requiredNames.count)) * 100

            let usesExpiring = present.contains { expiringSoon.contains($0) }
            let expiringBoost: Double = usesExpiring ? 25 : 0

            return RecipeMatch(
                recipe: recipe,
                availablePercent: percent,
                missingIngredients: missing,
                expiringBoost: expiringBoost
            )
        }

        let filtered = matches
            .filter { $0.availablePercent > 0 || preferredDiets.isEmpty || preferredDiets.contains($0.recipe.dietType) }
            .sorted { $0.score > $1.score }

        return Array(filtered.prefix(limit))
    }

    /// Interpretação simples do texto de ingredientes (linha por linha)
    static func parseIngredients(_ text: String) -> [String] {
        text
            .split(whereSeparator: { $0 == "\n" || $0 == "•" || $0 == "-" || $0 == "," })
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { stripQuantityAndUnit($0) }
            .filter { !$0.isEmpty }
    }

    private static func stripQuantityAndUnit(_ raw: String) -> String {
        var s = raw
        // Remove leading bullets, digits, unidades comuns
        let pattern = #"^[\d\./]+\s*(g|kg|ml|l|colher(es)?|xícara(s)?|dente(s)?|pitada|un|unidades?)?\s*de?\s*"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(s.startIndex..., in: s)
            s = regex.stringByReplacingMatches(in: s, options: [], range: range, withTemplate: "")
        }
        return s.trimmingCharacters(in: .whitespaces)
    }
}
