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

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

//        AuthorizationCenter.shared.requestAuthorization { result in
//            switch result {
//            case .success():
//                break
//            case .failure(let error):
//                print("Error for Family Controls: \(error)")
//            }
//        }

        ScheduleModel.setSchedule()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
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
