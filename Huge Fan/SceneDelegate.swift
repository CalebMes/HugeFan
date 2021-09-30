//
//  SceneDelegate.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/14/21.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let WindowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: WindowScene.coordinateSpace.bounds)
        window?.windowScene = WindowScene
        window?.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = .darkContent

        let realmObjc = try! Realm()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        if realmObjc.objects(usedPromotions.self).isEmpty == false{
            print(" CHECK RIGHT HERE!!!!!!!!", realmObjc.objects(usedPromotions.self)[0])
            realmObjc.objects(usedPromotions.self).forEach { (usedPromotions) in
                if usedPromotions.date != formatter.string(from: Date()){
                    try! realmObjc.write{
                        realmObjc.delete(usedPromotions)
                    }
                }
            }
        }
        
        if realmObjc.objects(usedQuestions.self).isEmpty == false{
            print("NUM OF ITEMS", realmObjc.objects(usedPromotions.self).count, realmObjc.objects(usedQuestions.self)[0])
            realmObjc.objects(usedQuestions.self).forEach { (usedQuestions) in
                if usedQuestions.date != formatter.string(from: Date()){
                    try! realmObjc.write{
                        realmObjc.delete(usedQuestions)
                    }
                }
            }
            
        }
        

        if realmObjc.objects(userObject.self).isEmpty{
            window?.rootViewController = UINavigationController(rootViewController: WelcomeView())
        }else{
            if realmObjc.objects(userObject.self)[0].isInfluencer{
                window?.rootViewController = UINavigationController(rootViewController: InfluecerLayoutController())
            }else{
                window?.rootViewController = UINavigationController(rootViewController: LayoutController())
            }
        }

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
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

