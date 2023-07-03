//
//  ShieldActionExtension.swift
//  ShieldActionExtension
//
//  Created by Astghik Hakopian on 19.12.22.
//

import ManagedSettings
import MobileCoreServices
import Foundation
import UIKit

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
//            let url = URL(string: "edbreak")
//            self.ext
//            (self as? UIResponder)?.extensionContext?.open(url)
//            UIApplication.shared.open(url!) { (result) in
//                if result {
//                   // The URL was delivered successfully!
//                }
//            }
//            ScheduleModel.
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qqq"), object: nil)
            sendNotification(title: "Do Exercises", body: "Tap on me to do exercises")
            let myAppUrl = URL(string: UIApplication.openSettingsURLString)!// URL(string: "edbreak://some-context")!
            
             NSExtensionContext().open(myAppUrl, completionHandler: { (success) in
                if success {
                   // completionHandler(.close)
                    // let the user know it failed
                } else {
                   // completionHandler(.defer)
                }
            })
            completionHandler(.close)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }
    
    
//    func openURL(_ url: URL) -> Bool {
//        var responder: UIResponder? = self
//        while responder != nil {
//            if let application = responder as? UIApplication {
//                return application.perform(#selector(openURL(_:)), with: url) != nil
//            }
//            responder = responder?.next
//        }
//        return false
//    }
}

//protocol UrlOpeningInIMessage {
//    func openFromiMessageContext(url:URL)
//}
//
//
//extension UrlOpeningInIMessage where Self: UIViewController {
//    func openFromiMessageContext(url:URL) {
//        let handler = { (success:Bool) -> () in
//            if success {
////                os_log("Finished opening URL", log:tgEnv.logImUI, type:.debug)
//            } else {
////                os_log("Failed to open URL", log:tgEnv.logImUI, type:.debug)
//            }
//        }
//        // logic same as onLaunchMainPressed, since XCode11 unable to compile extension using UIApplication.open
//        // so we pass the URL through to the parent app to launch on our behalf
//        let appName = "edbreak"//Bundle.main.appName()
//        let encodedUrl = url.dataRepresentation.base64EncodedString()
//        guard let appUrl: URL = URL(string: "\(appName)://?url=\(encodedUrl)") else { return }
//        // can only open our app, not generalised URLs
//        self.extensionContext?.open(appUrl, completionHandler: handler)
//    }
//}
//
//

let userNotificationCenter = UNUserNotificationCenter.current()

func sendNotification(title: String, body: String?) {
    requestNotificationAuthorization()
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = title
    notificationContent.body = body ?? title
    notificationContent.badge = NSNumber(value: 0)
    
    if let url = Bundle.main.url(forResource: "dune",
                                withExtension: "png") {
        if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                        url: url,
                                                        options: nil) {
            notificationContent.attachments = [attachment]
        }
    }
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                    repeats: false)
    let request = UNNotificationRequest(identifier: "testNotification",
                                        content: notificationContent,
                                        trigger: trigger)
    
    userNotificationCenter.add(request) { (error) in
        if let error = error {
            print("Notification Error: ", error)
        }
    }
}

func requestNotificationAuthorization() {
    let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
    
    userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
        if let error = error {
            print("Error: ", error)
        }
    }
}
