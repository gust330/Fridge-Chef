import SwiftUI
import SwiftData
#if canImport(UIKit)
import UIKit
#endif

@main
struct FridgeChefApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Ingredient.self,
            ShoppingItem.self,
            Recipe.self,
            UserPreference.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @AppStorage("themePreference") private var themePreference: String = "system"

    init() {
        Task { @MainActor in
            await NotificationService.requestAuthorization()
            NotificationService.scheduleDailyReminder()
        }
        #if canImport(UIKit) && !os(macOS)
        // Aparência padrão da NavigationBar coerente (apenas iOS/iPadOS)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        #endif
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }

    private var colorScheme: ColorScheme? {
        switch themePreference {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
