//
//  SceneDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 29/4/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var lastTimeExit: Date? // last time since the app enter the background


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.databaseController?.cleanup()
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if let last = lastTimeExit { // update the status of the active workout manager once the app enters the foreground again
//            print("Scence entered")
            let timePassed = Date.now.timeIntervalSince(lastTimeExit!)
//            print(timePassed)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if (appDelegate?.activeWorkoutManager?.active)! == true {
                appDelegate?.activeWorkoutManager?.timeskip(secondPassed: Int(timePassed))
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        lastTimeExit = Date()
//        print("Scene exited")
    }


}

