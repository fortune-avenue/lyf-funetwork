//
//  AppDelegate.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 28/10/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permission for push notifications denied.")
            }
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print("Remote notification received: \(userInfo)")
        
//        // Check if the app is in the foreground
//        if application.applicationState == .active {
//            // Manually display notification when app is in the foreground
//            if let aps = userInfo["aps"] as? [String: AnyObject],
//               let alert = aps["alert"] as? [String: String],
//               let title = alert["title"],
//               let body = alert["body"] {
//                
//                let content = UNMutableNotificationContent()
//                content.title = title
//                content.body = body
//                content.sound = .default
//                
//                // Show the notification immediately
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//                UNUserNotificationCenter.current().add(request) { error in
//                    if let error = error {
//                        print("Error showing notification: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//        
        return .newData
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print(fcm)
        }
    }
}
