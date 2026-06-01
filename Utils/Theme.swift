import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct AppTheme {
    // Cores Principais baseadas no PRD
    static let primaryGreen = Color("PrimaryGreen") // #34C759
    static let secondaryOrange = Color("SecondaryOrange") // #FF9500
    #if canImport(UIKit) && !os(macOS)
    static let backgroundLight = Color(UIColor.systemGroupedBackground)
    #else
    static let backgroundLight = Color(NSColor.windowBackgroundColor)
    #endif

    // Gradientes
    static let primaryGradient = LinearGradient(
        colors: [Color.appGreen, Color.appGreen.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Sombras Suaves (Premium UX)
    static func applySoftShadow<V: View>(to view: V) -> some View {
        view.shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

// Extensão para cores fallback de UI nativa
extension Color {
    static let appGreen = Color.green
    static let appOrange = Color.orange
    #if canImport(UIKit) && !os(macOS)
    static let appBackground = Color(UIColor.systemGroupedBackground)
    static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    #else
    static let appBackground = Color(NSColor.windowBackgroundColor)
    static let cardBackground = Color(NSColor.controlBackgroundColor)
    #endif
}
