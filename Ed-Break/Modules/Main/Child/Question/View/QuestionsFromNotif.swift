
import SwiftUI

enum MyViews {
    case viewA
    case viewB
    case viewC
}

class NotificationManager: NSObject, ObservableObject {
    @Published var currentViewId: MyViews?

    @ViewBuilder
    func currentView(for id: MyViews) -> some View {
        switch id {
        case .viewA:
            NotView()
        case .viewB:
            NotView()
        case .viewC:
            NotView()
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //App is in foreground
        //do whatever you want here, for example:
        currentViewId = .viewB
        completionHandler([.sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        //App is in background, user has tapped on the notification
        //do whatever you want here, for example:
        currentViewId = .viewB
        completionHandler()
    }
}
//
//import Foundation
//import NotificationCenter
//
//@MainActor
//open class LocalNotificationManager: NSObject, ObservableObject {
//    let notificationCenter = UNUserNotificationCenter.current()
//    @Published var isGranted = false
//    @Published var pendingRequests: [UNNotificationRequest] = []
//    @Published var nextView: NextView?
//
//    override init() {
//        super.init()
//        notificationCenter.delegate = self
//    }
//
//    func requestAuthorization() async throws {
//        try await notificationCenter
//            .requestAuthorization(options: [.sound, .badge, .alert])
//        registerActions()
//        await getCurrentSettings()
//    }
//
//    func getCurrentSettings() async {
//        let currentSettings = await notificationCenter.notificationSettings()
//        isGranted = (currentSettings.authorizationStatus == .authorized)
//    }
//
//    func openSettings() {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            if UIApplication.shared.canOpenURL(url) {
//                Task {
//                    await UIApplication.shared.open(url)
//                }
//            }
//        }
//    }
//
//    func schedule(localNotification: LocalNotification) async {
//        let content = UNMutableNotificationContent()
//        content.title = localNotification.title
//        content.body = localNotification.body
//        if let subtitle = localNotification.subtitle {
//            content.subtitle = subtitle
//        }
//        if let bundleImageName = localNotification.bundleImageName {
//            if let url = Bundle.main.url(forResource: bundleImageName, withExtension: "") {
//                if let attachment = try? UNNotificationAttachment(identifier: bundleImageName, url: url) {
//                    content.attachments = [attachment]
//                }
//            }
//        }
//        if let userInfo = localNotification.userInfo {
//            content.userInfo = userInfo
//        }
//        if let categoryIdentifier = localNotification.categoryIdentifier {
//            content.categoryIdentifier = categoryIdentifier
//        }
//
//        content.sound = .default
//        if localNotification.scheduleType == .time {
//        guard let timeInterval = localNotification.timeInterval else { return }
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
//                                                        repeats: localNotification.repeats)
//            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
//            try? await notificationCenter.add(request)
//        } else {
//            guard let dateComponents = localNotification.dateComponents else { return }
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
//            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
//            try? await notificationCenter.add(request)
//        }
//        await getPendingRequests()
//    }
//
//    func getPendingRequests() async {
//        pendingRequests = await notificationCenter.pendingNotificationRequests()
//        print("Pending: \(pendingRequests.count)")
//    }
//
//    func removeRequest(withIdentifier identifier: String) {
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
//        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
//            pendingRequests.remove(at: index)
//            print("Pending: \(pendingRequests.count)")
//        }
//    }
//
//    func clearRequests() {
//        notificationCenter.removeAllPendingNotificationRequests()
//        pendingRequests.removeAll()
//        print("Pending: \(pendingRequests.count)")
//    }
//}
//
//extension LocalNotificationManager: UNUserNotificationCenterDelegate {
//
//    func registerActions() {
//        let snooze10Action = UNNotificationAction(identifier: "snooze10", title: "Snooze 10 seconds")
//        let snooze60Action = UNNotificationAction(identifier: "snooze60", title: "Snooze 60 seconds")
//        let snoozeCategory = UNNotificationCategory(identifier: "snooze",
//                                                    actions: [snooze10Action, snooze60Action],
//                                                    intentIdentifiers: [])
//        notificationCenter.setNotificationCategories([snoozeCategory])
//    }
//
//    // Delegate function
//    public func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        await getPendingRequests()
//        return [.sound, .banner]
//    }
//
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//        if let value = response.notification.request.content.userInfo["nextView"] as? String {
//            nextView = NextView(rawValue: value)
//        }
//
//        // Respond to snooze action
//        var snoozeInterval: Double?
//        if response.actionIdentifier == "snooze10" {
//            snoozeInterval = 10
//        } else {
//            if response.actionIdentifier == "snooze60" {
//                snoozeInterval = 60
//            }
//        }
//
//        if let snoozeInterval = snoozeInterval {
//            let content = response.notification.request.content
//            let newContent = content.mutableCopy() as! UNMutableNotificationContent
//            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snoozeInterval, repeats: false)
//            let request = UNNotificationRequest(identifier: UUID().uuidString,
//                                                content: newContent,
//                                                trigger: newTrigger)
//            do {
//                try await notificationCenter.add(request)
//            } catch {
//                print(error.localizedDescription)
//            }
//
//            await getPendingRequests()
//        }
//    }
//
//}
//
//
//
//import Foundation
//
//public struct LocalNotification {
//    internal init(identifier: String,
//                  title: String,
//                  body: String,
//                  timeInterval: Double,
//                  repeats: Bool) {
//        self.identifier = identifier
//        self.scheduleType = .time
//        self.title = title
//        self.body = body
//        self.timeInterval = timeInterval
//        self.dateComponents = nil
//        self.repeats = repeats
//    }
//
//    internal init(identifier: String,
//                  title: String,
//                  body: String,
//                  dateComponents: DateComponents,
//                  repeats: Bool) {
//        self.identifier = identifier
//        self.scheduleType = .calendar
//        self.title = title
//        self.body = body
//        self.timeInterval = nil
//        self.dateComponents = dateComponents
//        self.repeats = repeats
//    }
//
//    enum ScheduleType {
//        case time, calendar
//    }
//
//    var identifier: String
//    var scheduleType: ScheduleType
//    var title: String
//    var body: String
//    var subtitle: String?
//    var bundleImageName: String?
//    var userInfo: [AnyHashable : Any]?
//    var timeInterval: Double?
//    var dateComponents: DateComponents?
//    var repeats: Bool
//    var categoryIdentifier: String?
//}
//
//
//
//
//import SwiftUI
//
//enum NextView: String, Identifiable {
//    case promo, renew
//    var id: String {
//        self.rawValue
//    }
//
//    @ViewBuilder
//    func view() -> some View {
//        switch self {
//        case .promo:
//            Text("Promotional Offer")
//                .font(.largeTitle)
//        case .renew:
//            VStack {
//                Text("Renew Subscription")
//                    .font(.largeTitle)
//               Image(systemName: "dollarsign.circle.fill")
//                    .font(.system(size: 128))
//            }
//        }
//    }
//}
