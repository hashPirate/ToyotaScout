//
//  SceneDelegate.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
       
        /*Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else {
                print("corporate")
               return
            }*/
            if let user = Auth.auth().currentUser {
                
                if user.uid == ""{
                            var numberOfMessages = UserDefaults.standard.integer(forKey: "numberOfMessages")
                            var numberOfCalls = UserDefaults.standard.integer(forKey: "numberOfCalls")
                            print("paluzone2")
                            if numberOfCalls < 2 && numberOfMessages < 10{
                                print("bamuzom2")
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "VoicePage") as? VoicePage // Replace with your main view controller
                                vc?.userID = user.uid ?? ""
                                self.window?.rootViewController = vc
                                
                                self.window?.makeKeyAndVisible()
                            }
                            else{
                                print("garam \(self.window?.rootViewController)")
                                if let rootVC = self.window?.rootViewController as? SignUp {
                                    // Call your function here
                                    
                                    print("bobs")
                                    rootVC.dismissLoader()
                                }
                            }
                        }
                        else{
                            //Auth.auth().currentUser?.reload(completion: { [self] err in
                            print("hola como estas")
                            //if(err != nil){
                            print("errawr")
                            var numberOfMessages = UserDefaults.standard.integer(forKey: "numberOfMessages")
                            var numberOfCalls = UserDefaults.standard.integer(forKey: "numberOfCalls")
                            print("paluzone \(Auth.auth().currentUser?.uid) \(Auth.auth().currentUser?.uid)")
                            if numberOfCalls < 2 && numberOfMessages < 10{
                                print("bamuzom")
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "VoicePage") as? VoicePage // Replace with your main view controller
                                vc?.userID = user.uid ?? ""
                                self.window?.rootViewController = vc
                                
                                self.window?.makeKeyAndVisible()
                            }
                            //}
                            //else{
                            print("hizo")
                            if((user.isEmailVerified == true) || (user.phoneNumber != nil)){
                                print("grom", Auth.auth().currentUser?.phoneNumber)
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "VoicePage") as? VoicePage // Replace with your main view controller
                                vc?.userID = user.uid ?? ""
                                self.window?.rootViewController = vc
                                
                                self.window?.makeKeyAndVisible()
                                
                                
                            }
                            else{
                                var numberOfMessages = UserDefaults.standard.integer(forKey: "numberOfMessages")
                                var numberOfCalls = UserDefaults.standard.integer(forKey: "numberOfCalls")
                                print("paluzone")
                                if numberOfCalls < 2 && numberOfMessages < 10{
                                    print("bamuzom")
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let vc = storyBoard.instantiateViewController(withIdentifier: "VoicePage") as? VoicePage // Replace with your main view controller
                                    vc?.userID = user.uid ?? ""
                                    self.window?.rootViewController = vc
                                    
                                    self.window?.makeKeyAndVisible()
                                }
                                else{
                                    print("garam \(self.window?.rootViewController)")
                                    if let rootVC = self.window?.rootViewController as? SignUp {
                                        print("bobs")
                                        // Call your function here
                                        rootVC.dismissLoader()
                                    }
                                }
                                
                            }
                            //}
                            //})
                        
                        print("User reloaded successfully")
                    
                }
                
            }
            else{
                
                var numberOfMessages = UserDefaults.standard.integer(forKey: "numberOfMessages")
                var numberOfCalls = UserDefaults.standard.integer(forKey: "numberOfCalls")
                print("paluzone2")
                if numberOfCalls < 2 && numberOfMessages < 10{
                    print("bamuzom2")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "VoicePage") as? VoicePage // Replace with your main view controller
                   // vc?.userID = user?.uid ?? ""
                    window?.rootViewController = vc
                    
                    self.window?.makeKeyAndVisible()
                }
                else{
                    print("garam \(window?.rootViewController)")
                    
                    if let rootVC = window?.rootViewController as? SignUp {
                        print("bobs \(rootVC.loadingScreen)")
                        // Call your function here
                        rootVC.dismissLoader()
                    }
                }
            }
        //}
        
       
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

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
        print("Helo!")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Helo!2")
        if let rootVC = window?.rootViewController {
                    rootVC.view.endEditing(true)
                }
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

