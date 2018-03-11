//
//  AppDelegate.swift
//  AppSchool
//
//  Created by Ahmad on 1/11/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit
import Reachability
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var reachability:Reachability!
    var deviceToken: String = "111111"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*
        self.window = UIWindow(frame:UIScreen.main.bounds)
        if let window = self.window{
            window.backgroundColor = UIColor.white
            let nav = UINavigationController()
            let mainView = ViewController()
            nav.viewControllers = [mainView]
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
        */
        IQKeyboardManager.sharedManager().enable = true
        
        //Register notifications
        self.athurizeNotifications(application)
        
        //Reachability
        reachability = Reachability()!
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("Unable to create Reachability")
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Reachability
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
        } else {
            print("Network not reachable")
        }
    }
    
    // MARK: - Push Notifications
    
    func athurizeNotifications(_ application: UIApplication) {
    
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                guard error == nil else {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                
                if granted {
                    //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
                    //application.registerForRemoteNotifications()
                }
                else {
                    //Handle user denying permissions..
                }
            }
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        self.deviceToken = deviceTokenString as String
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        if application.applicationState == .active {
            //write your code here when app is in foreground
        } else {
            //write your code here for other state
        }
    }
    
    func getUserToken() -> String {
        let dictUser = USER_DEFAULTS.value(forKey: LOGGEDIN_USER_INFO) as? NSDictionary
        return dictUser![USER_TOKEN] as! String
    }
}

