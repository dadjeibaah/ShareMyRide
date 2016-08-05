//
//  SignupViewController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 7/24/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
import Stormpath

class SignupViewController:UIViewController{
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRetype: UITextField!
    
    @IBAction func signup(sender: AnyObject) {
        guard let userPassword = password.text where isMatch(self.password.text!, match: self.passwordRetype.text!) && isEntered(self.password.text!) else{
            print("user password not valid")
            return
        }
        
        guard let givenName = firstName.text else {
            print("no firstName entered")
            return
        }
        guard let surname = lastName.text else{
            print("no surname entered")
            return
        }
        guard let email = email.text else{
            print("no email entered")
            return
        }
        
        let newUser = RegistrationModel(email: email, password: userPassword)
        newUser.givenName = givenName
        newUser.surname = surname
        
        Stormpath.sharedSession.register(newUser){
            (account, error) in
            if let error = error {
                print(error)
            }else{
                print(account!)
                self.backToLogin(self)
            }
        }
    }
    
    func isMatch(password:String, match:String) -> Bool{
        return password == match
    }
    
    func isEntered(password:String) -> Bool{
        return password.characters.count > 0
    }
    
    @IBAction func backToLogin(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToLogin", sender: self)
    }
}