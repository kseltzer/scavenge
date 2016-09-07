//
//  LoginViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBAction func fbLoginButtonPressed (sender: UIButton!) {
        self.attemptLoginWithFacebook()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.handleLoggedIn()
        }
    }
    
    func attemptLoginWithFacebook() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile", "user_friends"], fromViewController: self, handler: { (fbResult: FBSDKLoginManagerLoginResult!, error: NSError!) ->
            Void in
            if (error != nil) {
                self.handleLoginError()
                print("Facebook login failed. Error \(error)")
            } else if fbResult.isCancelled {
                print("cancelled")
            } else {
                print("Successfully logged into Facebook.")
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print(accessToken)
                NSUserDefaults.standardUserDefaults().setValue(accessToken, forKey: KEY_UID)
            }
        })
    }
    
    func handleLoginError() {
        let alertController = UIAlertController(title: kErrorTitle, message: "There was an error logging into Facebook. Please try again.", preferredStyle: .Alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .Default) { (alert) in
            self.attemptLoginWithFacebook()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func handleLoggedIn() {
        if let appDelegate = UIApplication.sharedApplication().delegate {
            let mainStoryboard = UIStoryboard(name: kMainStoryboard, bundle: nil)
            let myScavengesViewController = mainStoryboard.instantiateInitialViewController()
            appDelegate.window!!.rootViewController?.presentViewController(myScavengesViewController!, animated: true, completion: nil)
        }
    }
    
    
}
