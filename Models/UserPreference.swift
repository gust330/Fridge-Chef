import Foundation
import SwiftData

@Model
final class UserPreference {
    var id: UUID
    var preferredDiets: [String]
    var excludedIngredients: [String]
    var allergens: [String]
    var servingDefault: Int
    var notificationsEnabled: Bool
    var hapticsEnabled: Bool
    var themePreference: String // "system", "light", "dark"
    var goal: String // "Comer melhor", "Rápidas", "Alta proteína", "Conforto"

    init(
        id: UUID = UUID(),
        preferredDiets: [String] = [],
        excludedIngredients: [String] = [],
        allergens: [String] = [],
        servingDefault: Int = 2,
        notificationsEnabled: Bool = true,
        hapticsEnabled: Bool = true,
        themePreference: String = "system",
        goal: String = "Comer melhor"
    ) {
        self.id = id
        self.preferredDiets = preferredDiets
        self.excludedIngredients = excludedIngredients
        self.allergens = allergens
        self.servingDefault = servingDefault
        self.notificationsEnabled = notificationsEnabled
        self.hapticsEnabled = hapticsEnabled
        self.themePreference = themePreference
        self.goal = goal
    }
}
