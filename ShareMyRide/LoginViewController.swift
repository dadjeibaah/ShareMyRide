//
//  LoginViewController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 5/23/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
import Stormpath
import PDKeychainBindingsController

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var bindings:PDKeychainBindings!
    
    override func viewDidLoad() {
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        bindings = PDKeychainBindings.sharedKeychainBindings()
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil)
        {
            print("Unable to login with Facebook")
        }
        else if result.isCancelled {
            print("User cancelled login")
        }
        else {
            returnUserData()
        }
        
        
        
    }
    @IBAction func signUpUser(sender: AnyObject) {
        
    }
    
    @IBAction func loginUser(sender: AnyObject) {
        guard let username = username.text else{
            return
        }
        guard let password = password.text else{
            return
        }
        Stormpath.sharedSession.login(username, password: password){
            (isLoggedIn, error) in
            if(isLoggedIn){
                guard let access = Stormpath.sharedSession.accessToken else{
                    return
                }
                guard let refresh = Stormpath.sharedSession.refreshToken else{
                    return
                }
                self.bindings.setObject(access, forKey: "authToken")
                self.bindings.setObject(refresh, forKey: "refreshToken")
                self.transitionToMainViewController()
                
            }else{
                print(error)
                let cancel:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                let alert = UIAlertController(title: "Login Failed", message: "It seems you dont have an account", preferredStyle: .ActionSheet)
                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func returnUserData()
    {
        let params = ["fields":"first_name, last_name, email"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                
                let firstName : String = result?.valueForKey("first_name") as! String
                let lastName : String = result.valueForKey("last_name") as! String
                let email : String = result.valueForKey("email") as! String
                
                
                let newUser = Users(id:nil, firstName: firstName,lastName: lastName, email: email, communities: [Communities]())
                newUser.post({ (user:Users) in
                    print(user)
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "LoginState")
                    self.transitionToMainViewController()
                }) { (error) in
                    print(error)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}
}
