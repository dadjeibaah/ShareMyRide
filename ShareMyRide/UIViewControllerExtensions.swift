//
//  UIViewControllerExtensions.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 6/4/16.

//  Code from http://jcavar.me/blog/2015/03/14/login-tabbar/
//

import Foundation
import UIKit

extension UIViewController {
    
    func transitionToMainViewController() {
        
        if let window = self.view.window {
            UIView.transitionWithView(window, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                window.rootViewController = storyboard.instantiateInitialViewController()! as UIViewController
                }, completion: nil)
        }
    }
    
    func transitionToLoginViewController() {
        
        if let window = self.view.window {
            UIView.transitionWithView(window, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                window.rootViewController = storyboard.instantiateInitialViewController()! as UIViewController
                }, completion: nil)
        }
    }
    
    func showAlert(title:String, message:String, okAction:(UIAlertAction) -> Void){
        let action = UIAlertAction(title: "Ok", style: .Default, handler: okAction)
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}