import Foundation

struct RecipeMatch {
    let recipe: Recipe
    let availablePercent: Double
    let missingIngredients: [String]
    let expiringBoost: Double

    var score: Double {
        availablePercent * 0.6 + expiringBoost
    }
}
