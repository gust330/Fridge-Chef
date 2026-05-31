import Foundation
import SwiftData

@Model
final class Recipe {
    var id: UUID
    var title: String
    var mealType: String
    var dietType: String
    var prepTime: Int // Em minutos
    var cookTime: Int
    var difficulty: String
    var calories: Int?
    var isFavorite: Bool
    var lastCookedAt: Date?
    
    // In a real app, relationships or Codable structs would be used for ingredients/steps
    var ingredientsText: String 
    var stepsText: String
    
    init(id: UUID = UUID(), title: String, mealType: String, dietType: String, prepTime: Int, cookTime: Int, difficulty: String, ingredientsText: String, stepsText: String, calories: Int? = nil, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.mealType = mealType
        self.dietType = dietType
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.difficulty = difficulty
        self.ingredientsText = ingredientsText
        self.stepsText = stepsText
        self.calories = calories
        self.isFavorite = isFavorite
    }
}
