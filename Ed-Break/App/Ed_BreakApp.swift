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
    let appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(model)
                .environmentObject(store)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

//        AuthorizationCenter.shared.requestAuthorization { result in
//            switch result {
//            case .success():
//                break
//            case .failure(let error):
//                print("Error for Family Controls: \(error)")
//            }
//        }
        UNUserNotificationCenter.current().delegate = self
        ScheduleModel.setSchedule()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // ScheduleModel.setSchedule()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil)
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // ScheduleModel.setSchedule()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        let apps: FamilyActivitySelection? = UserDefaultsService().getObject(forKey: .ChildUser.restrictedApps)
//        DataModel.shared.selectionToDiscourage = apps ?? DataModel.shared.selectionToEncourage
//        DataModel.shared.selectionToEncourage = FamilyActivitySelection()
//        DataModel.shared.threshold = DateComponents()
//        DataModel.shared.setShieldRestrictions()
//
//        completionHandler()
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
//        let apps: FamilyActivitySelection? = UserDefaultsService().getObject(forKey: .ChildUser.restrictedApps)
//        DataModel.shared.selectionToDiscourage = apps ?? DataModel.shared.selectionToEncourage
//        DataModel.shared.selectionToEncourage = FamilyActivitySelection()
//        DataModel.shared.threshold = DateComponents()
//        DataModel.shared.setShieldRestrictions()
//
        completionHandler([.alert, .badge, .sound])
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
