//
//  AppDelegate.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/8/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func applicationDidEnterBackground(_ application: UIApplication) {
            // Handle app entering background
            print("App entered background.")
            // You can save state or stop tasks here if needed.
        }
    func applicationWillEnterForeground(_ application: UIApplication) {
            // Handle app coming back to foreground
            print("App will enter foreground.")
            NotificationCenter.default.post(name: NSNotification.Name("AppWillEnterForeground"), object: nil)
        }
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        /*let authListener = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            print("sending somewhere")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if(user != nil){
                print("sending to home")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "VoicePage") as? VoicePage // Replace with your main view controller
                vc?.userID = user?.uid ?? ""
                window?.rootViewController = vc
                
                self.window?.makeKeyAndVisible()
                
            }
            else{
                print("nahhh")
            }
        }*/

                    
                    // Show the login screen
        
        // Override point for customization after application launch.
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

