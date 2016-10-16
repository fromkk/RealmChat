//
//  AppDelegate.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var members: Results<Member>?
    var notificationToken: NotificationToken?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame: UIApplication.shared.keyWindow?.bounds ?? UIScreen.main.bounds)
        self.window?.rootViewController = IndicatorViewController(nibName: nil, bundle: nil)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()

        if let user: SyncUser = SyncUser.all().first {
            RealmConstants.setDefaultUser(user: user)
            self.controlRootViewController()
            self.startNotification()
        } else {
            let credential: Credential = Credential.accessToken(RealmConstants.adminToken, identity: RealmConstants.identity)
            SyncUser.authenticate(with: credential, server: RealmConstants.authURL, timeout: 30.0) { [weak self] (user, error) in

                if let user = user {
                    RealmConstants.setDefaultUser(user: user)
                    self?.controlRootViewController()
                    self?.startNotification()
                } else if let error = error {
                    print("login failed \(error)")
                }
            }
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

    deinit {
        self.notificationToken?.stop()
    }
}

extension AppDelegate {
    fileprivate func startNotification() {
        guard nil == self.notificationToken else {
            return
        }
        
        let realm: Realm = try! Realm()
        self.members = realm.objects(Member.self)
        self.notificationToken = self.members?.addNotificationBlock({ [weak self] (changes) in
            guard let _ = Member.currentMember else {
                return
            }
            self?.controlRootViewController()
        })
    }
    
    func controlRootViewController() {
        var rootViewController: UIViewController?
        if let _ = Member.currentMember {
            rootViewController = UIStoryboard(name: "Top", bundle: Bundle.main).instantiateInitialViewController()
        } else {
            rootViewController = UIStoryboard(name: "Entrance", bundle: Bundle.main).instantiateInitialViewController()
        }

        self.window?.rootViewController = rootViewController
    }
}
