//
//  AppDelegate.swift
//  SnsLoginFeature
//
//  Created by Jh's MacbookPro on 2020/05/26.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import TwitterKit
import YJLoginSDK

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var googleDelegate : GIDGoogleUser?
        
    let clientId = "dj00aiZpPVlXWnFvUTNzTk5rRyZzPWNvbnN1bWVyc2VjcmV0Jng9ODg-"
    let redirectUri = URL(string: "yj-3va20:/")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance()?.clientID = "354059384857-vqe2lka577am81tc15qopl9jamjo3ohp.apps.googleusercontent.com"
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        TWTRTwitter.sharedInstance().start(withConsumerKey:"FoYMnWrHg1WwmrURtmKCOYgp8", consumerSecret:"WLANZya0FzH2bGom5SwXB3gzDQ2hfcR3pFv0dhzzyi9bjrXcEy")
        LoginManager.shared.setup(clientId: clientId, redirectUri: redirectUri)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        if GIDSignIn.sharedInstance().handle(url) {
           return true
        }
        else if ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]){
         return true
        }
        else if TWTRTwitter.sharedInstance().application(app, open: url, options: options){
            return true
        }
        else if LoginManager.shared.application(app, open: url, options: options){
            return true
        }

        return false
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

