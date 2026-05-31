import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var id: UUID
    var name: String
    var quantity: Double
    var unit: String
    var category: String
    var isChecked: Bool
    var linkedIngredientId: UUID?
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, quantity: Double, unit: String, category: String, isChecked: Bool = false, linkedIngredientId: UUID? = nil) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.category = category
        self.isChecked = isChecked
        self.linkedIngredientId = linkedIngredientId
        self.createdAt = Date()
    }
}
