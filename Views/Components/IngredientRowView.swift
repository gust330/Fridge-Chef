import SwiftUI
import SwiftData

struct IngredientRowView: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack(spacing: 16) {
            // Ícone da categoria (Placeholder visual)
            ZStack {
                Circle()
                    .fill(Color.appGreen.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconForCategory(ingredient.category))
                    .foregroundColor(.appGreen)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("\(ingredient.quantity, specifier: "%.1f") \(ingredient.unit)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Badge de Estado
                    statusBadge(status: ingredient.status)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "frutas": return "applelogo"
        case "vegetais": return "leaf.fill"
        case "lacticínios": return "drop.fill"
        case "carnes": return "hare.fill" // placeholder
        default: return "shippingbox.fill"
        }
    }
    
    @ViewBuilder
    private func statusBadge(status: String) -> some View {
        Text(status.uppercased())
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(colorForStatus(status).opacity(0.2))
            .foregroundColor(colorForStatus(status))
            .clipShape(Capsule())
    }
    
    private func colorForStatus(_ status: String) -> Color {
        switch status.lowercased() {
        case "disponível": return .appGreen
        case "a acabar": return .appOrange
        case "esgotado": return .red
        default: return .gray
        }
    }
}
