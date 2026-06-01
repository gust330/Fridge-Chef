import Foundation
#if canImport(UIKit)
import UIKit
#endif

@MainActor
enum HapticsService {
    static func light() {
        #if canImport(UIKit) && !os(macOS)
        let g = UIImpactFeedbackGenerator(style: .light)
        g.impactOccurred()
        #endif
    }

    static func medium() {
        #if canImport(UIKit) && !os(macOS)
        let g = UIImpactFeedbackGenerator(style: .medium)
        g.impactOccurred()
        #endif
    }

    static func heavy() {
        #if canImport(UIKit) && !os(macOS)
        let g = UIImpactFeedbackGenerator(style: .heavy)
        g.impactOccurred()
        #endif
    }

    static func success() {
        #if canImport(UIKit) && !os(macOS)
        let g = UINotificationFeedbackGenerator()
        g.notificationOccurred(.success)
        #endif
    }

    static func warning() {
        #if canImport(UIKit) && !os(macOS)
        let g = UINotificationFeedbackGenerator()
        g.notificationOccurred(.warning)
        #endif
    }

    static func selection() {
        #if canImport(UIKit) && !os(macOS)
        let g = UISelectionFeedbackGenerator()
        g.selectionChanged()
        #endif
    }
}
