import UIKit

@MainActor
enum HapticsService {
    static func light() {
        let g = UIImpactFeedbackGenerator(style: .light)
        g.impactOccurred()
    }

    static func medium() {
        let g = UIImpactFeedbackGenerator(style: .medium)
        g.impactOccurred()
    }

    static func heavy() {
        let g = UIImpactFeedbackGenerator(style: .heavy)
        g.impactOccurred()
    }

    static func success() {
        let g = UINotificationFeedbackGenerator()
        g.notificationOccurred(.success)
    }

    static func warning() {
        let g = UINotificationFeedbackGenerator()
        g.notificationOccurred(.warning)
    }

    static func selection() {
        let g = UISelectionFeedbackGenerator()
        g.selectionChanged()
    }
}
