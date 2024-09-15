//
//  AppDelegate.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 14/09/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            var alertController = UIAlertController(title: "Title", message: "Any message", preferredStyle: .actionSheet)
            var okAction = UIAlertAction(title: "Yes", style: .default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
            alertController.addAction(okAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        return true
    }
}

