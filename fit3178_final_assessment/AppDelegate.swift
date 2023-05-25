//
//  AppDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 29/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var databaseController: SyncController?
    var coreDataController: CoreDataController?
    var firebaseController: FirebaseController? // remove after testing
    var firebaseAuthController: FirebaseAuthenticationDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UNUserNotificationCenter.current().delegate = self
        
        databaseController = SyncController()
        coreDataController = CoreDataController()
        firebaseController = FirebaseController() // remove after testing
        databaseController!.coreDataController = coreDataController
        databaseController!.firebaseController = firebaseController
        firebaseAuthController = firebaseController
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

