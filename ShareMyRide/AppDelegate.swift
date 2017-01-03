//
//  AppDelegate.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/17/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import UIKit
import Alamofire
import AlamoArgo
import CoreData
import Stormpath
import PDKeychainBindingsController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    var bindings:PDKeychainBindings!
    var loginStoryboard:UIStoryboard!
    var mainStoryBoard:UIStoryboard!
    var loaderStoryboard:UIStoryboard!
  


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        loaderStoryboard = UIStoryboard(name:"Loader", bundle: nil)
        loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        mainStoryBoard = UIStoryboard(name: "Main", bundle:nil)
        
        let optionsBool = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.window?.rootViewController = self.loaderStoryboard.instantiateInitialViewController()! as UIViewController
        StormpathConfiguration.defaultConfiguration.APIURL = NSURL(string: "http://localhost:8000")!
        if let token = Stormpath.sharedSession.accessToken{
            let headers = ["Authorization": "\(token)"]
            Alamofire.request(.GET, "http://localhost:8000/oauth/verify", headers:headers)
                .validate()
                .responseJSON { (response:Response<AnyObject, NSError>) in
                    switch response.result{
                    case .Success:
                        self.window?.rootViewController?.transitionToMainViewController()
                    case .Failure(let error):
                        print(error)
                        self.window?.rootViewController?.transitionToLoginViewController()
                    }
                    
                    
            }
        }else if (FBSDKAccessToken.currentAccessToken() != nil){
            self.window?.rootViewController?.transitionToMainViewController()
        }
        else{
             self.window?.rootViewController?.transitionToLoginViewController()
        }
       
        
//        // Override point for customization after application launch.
//        Stormpath.sharedSession.refreshAccessToken({ (isLoggedIn:Bool, error:NSError?) in
//            print(error)
//            if !isLoggedIn{
//                self.window?.rootViewController = self.loginStoryboard.instantiateInitialViewController()! as UIViewController
//            }else{
//                self.window?.rootViewController = self.mainStoryBoard.instantiateInitialViewController()! as UIViewController
//            }
//        })

        
       
        return optionsBool
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func AlamofireBootStrap(){
//        {
//            (isLoggedIn, error) in
//            if !isLoggedIn{
//                let storyboard = UIStoryboard(name: "Login", bundle: nil)
//                self.window?.rootViewController = storyboard.instantiateInitialViewController()! as UIViewController
//            }
//        }
    }
    
    


}

