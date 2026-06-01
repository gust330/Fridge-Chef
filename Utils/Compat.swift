import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Helpers de Compatibilidade iOS / macOS
// Estas extensões evitam espalhar #if os(iOS) por todo o código.

extension View {
    /// Esconde a barra de navegação de forma compatível com iOS e macOS.
    @ViewBuilder
    func hideNavigationBar() -> some View {
        #if os(iOS)
        self.navigationBarHidden(true)
        #else
        self.toolbar(.hidden, for: .windowToolbar)
        #endif
    }

    /// Aplica Dynamic Type apenas em iOS.
    @ViewBuilder
    func applyDynamicType(_ size: DynamicTypeSize) -> some View {
        #if os(iOS)
        self.environment(\.dynamicTypeSize, size)
        #else
        self
        #endif
    }

    /// List style compatível.
    @ViewBuilder
    func compatListStyle() -> some View {
        #if os(iOS)
        self.listStyle(.insetGrouped)
        #else
        self.listStyle(.inset)
        #endif
    }

    /// Swipe actions + context menu (fallback macOS).
    @ViewBuilder
    func compatSwipeActions<Content: View>(
        edge: HorizontalEdge = .trailing,
        allowsFullSwipe: Bool = false,
        @ViewBuilder content: () -> Content
    ) -> some View {
        #if os(iOS)
        self.swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe, content: content)
        #else
        // No macOS, usamos contextMenu como fallback
        self.contextMenu(menuItems: content)
        #endif
    }
}

extension ToolbarItemPlacement {
    /// Placement compatível para ações à direita/direita.
    static var compatTrailing: ToolbarItemPlacement {
        #if os(iOS)
        return .topBarTrailing
        #else
        return .primaryAction
        #endif
    }

    /// Placement compatível para ações à esquerda.
    static var compatLeading: ToolbarItemPlacement {
        #if os(iOS)
        return .topBarLeading
        #else
        return .cancellationAction
        #endif
    }
}

// MARK: - Cor de fundo segura
extension Color {
    /// Cor de fundo de list/inset (compatível iOS/macOS).
    static var compatInsetBackground: Color {
        #if canImport(UIKit)
        return Color(.secondarySystemGroupedBackground)
        #else
        return Color(NSColor.controlBackgroundColor)
        #endif
    }
}
