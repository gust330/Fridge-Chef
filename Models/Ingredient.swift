import Foundation
import SwiftData

@Model
final class Ingredient {
    var id: UUID
    var name: String
    var normalizedName: String
    var quantity: Double
    var unit: String
    var category: String
    var storageLocation: String // Frigorífico, Congelador, Despensa
    var expiryDate: Date?
    var status: String // Disponível, A acabar, Esgotado
    var isFavorite: Bool
    var isRecurring: Bool
    var notes: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(), name: String, quantity: Double, unit: String, category: String, storageLocation: String, expiryDate: Date? = nil, status: String = "Disponível", isFavorite: Bool = false, isRecurring: Bool = false, notes: String? = nil) {
        self.id = id
        self.name = name
        self.normalizedName = name.lowercased()
        self.quantity = quantity
        self.unit = unit
        self.category = category
        self.storageLocation = storageLocation
        self.expiryDate = expiryDate
        self.status = status
        self.isFavorite = isFavorite
        self.isRecurring = isRecurring
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
