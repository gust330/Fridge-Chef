import Foundation
import UserNotifications

enum NotificationService {
    static func requestAuthorization() async {
        do {
            _ = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            // ignore
        }
    }

    /// Agenda um lembrete diário para o utilizador ver o que tem em casa
    static func scheduleDailyReminder(hour: Int = 19, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])

        let content = UNMutableNotificationContent()
        content.title = "O que vamos cozinhar hoje?"
        content.body = "Tens ingredientes a expirar. Abre o FridgeChef para decidir."
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let req = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        center.add(req)
    }
}
