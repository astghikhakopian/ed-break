//
//  Ed_BreakApp.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI
import FamilyControls
import ManagedSettings

@main
struct Ed_BreakApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject var model = DataModel.shared
    @StateObject var store = ManagedSettingsStore()
    @StateObject var networkMonitor = NetworkMonitor()
    
    let appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(model)
                .environmentObject(store)
                .environmentObject(networkMonitor)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UserDefaultsService().setPrimitive(true, forKey: .ChildUser.shouldShowExercises)
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UserDefaultsService().setPrimitive(true, forKey: .ChildUser.shouldShowExercises)
        completionHandler([.alert, .badge, .sound])
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        DefaultTextToSpeachManager.sharedInstance.stop(at: .immediate)
    }
}


/// Extension

extension View {
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(
            center.publisher(for: name, object: object),
            perform: action
        )
    }
}
