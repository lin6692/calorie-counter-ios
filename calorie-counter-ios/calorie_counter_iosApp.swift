//
//  calorie_counter_iosApp.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/5/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct calorie_counter_iosApp: App {
    // connecting AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(SessionManager.shared)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application:UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        
        // Initializing FireBase
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
