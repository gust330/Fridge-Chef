import SwiftUI

struct AppTheme {
    // Cores Principais baseadas no PRD
    static let primaryGreen = Color("PrimaryGreen") // No Xcode, você criará esta cor nos Assets (ex: #34C759)
    static let secondaryOrange = Color("SecondaryOrange") // Ex: #FF9500
    static let backgroundLight = Color(UIColor.systemGroupedBackground)
    
    // Gradientes
    static let primaryGradient = LinearGradient(
        colors: [primaryGreen, primaryGreen.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Sombras Suaves (Premium UX)
    static func applySoftShadow(to view: some View) -> some View {
        view.shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

// Extensão para cores fallback de UI nativa enquanto os Assets não são criados no Mac
extension Color {
    static let appGreen = Color.green
    static let appOrange = Color.orange
    static let appBackground = Color(UIColor.systemGroupedBackground)
    static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
}
