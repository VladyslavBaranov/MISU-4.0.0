//
//  AppDelegate.swift
//  CoronaVirTracker
//
//  Created by Dmitriy Kruglov on 3/12/20.
//  Copyright © 2020 CVTCompany. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import YCProductSDK
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func test() {
        IndicatorManager.shared.performServerDataImport()
        RealmImage.clearExpiredImages()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // NetworkAvailabilityObserver.shared.start()
        HealthDataCenter.shared.execute()
        
        test()
        
        LocalDataManager.shared.performActionsOnAppLaunch()
        ChatLocalManager.shared.startObserving()
        
        setupNotifications(launchOptions)
        setupGeneral()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let instance = MainTabBarController.createInstance()
        window?.rootViewController = instance
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("### N uI \(userInfo)")
        //ChatsSinglManager.shared.appIconDelegate?.gotNewMessage(1)
        //PushNotificationManager.shared.didReceiveRemoteNotification(userInfo: userInfo)
        completionHandler(.newData)
        //application.applicationIconBadgeNumber = 1
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotificationManager.shared.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PushNotificationManager.shared.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // completionHandler([.alert, .badge, .sound])
        completionHandler([.badge, .sound])
        print("### N \(notification)")
        PushNotificationManager.shared.userNotificationCenterwillPresent(notification: notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("### didReceive response \(userInfo)")
        let tabBarController = self.window?.rootViewController as? UITabBarController
        let navController = tabBarController?.selectedViewController as? UINavigationController
        //print("### navController \(String(describing: navController))")
        PushNotificationManager.shared.didReceiveRemoteNotification(userInfo: userInfo, navController: navController)
        completionHandler()
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let watch = WatchConnectionManager.shared.currentWatch() {
            if watch is AppleWatch {
                print("RELOAD APPLE WATCH DATA")
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

private extension AppDelegate {
    
    func performOnAppActions() {
        UserManager.shared.updateUserWithRealmIfNeeded()
    }
    
    func removeSplashBoard() {
        do {
           try FileManager.default.removeItem(atPath: NSHomeDirectory() + "/Library/SplashBoard")
        } catch {
           print("Failed to delete launch screen cache: \(error)")
        }
    }
    
    func setupNotifications(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        UNUserNotificationCenter.current().delegate = self
        PushNotificationManager.shared.didFinishLaunchingWithOptions(launchOptions)
    }
    
    func setupUCardSingleManager() {
//        _ = KeychainUtils.removeCurrentUserToken()
        /*
        if UCardSingleManager.shared.isUserToken() {
            UCardSingleManager.shared.getCurrUser(request: true)
        } else {
            UCardSingleManager.shared.user.getFromUserDef()
        }
         */
    }
    
    func setupGeneral() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        // ListDHUSingleManager.shared.updateDefaultLists()
        ChatsSinglManager.shared.updateUnreadedChatsCount()

        FirebaseApp.configure()
    }
}

extension AppDelegate: WatchDataReaderDelegate {
    func didFinishReadingSleepData(_ reader: WatchDataReader) {
        
    }
    
    func didFinishReadingData(_ reader: WatchDataReader) {
    }
}
