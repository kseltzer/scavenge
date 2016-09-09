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
                NSUserDefaults.standardUserDefaults().setValue(accessToken, forKey: KEY_UID)
                self.getFacebookUserData()
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
        let mainStoryboard = UIStoryboard(name: kMainStoryboard, bundle: nil)
        let myScavengesViewController = mainStoryboard.instantiateInitialViewController()
        self.presentViewController(myScavengesViewController!, animated: true, completion: nil)
    }
    
    
    func getFacebookUserData() {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error != nil) {
                print("Error: \(error)")
            } else {
                let firstName = result["first_name"]
                let lastName = result["last_name"]
                var profileImageURL : String?
                if let profileImageDict = result["picture"] as? NSDictionary {
                    if let pictureData = profileImageDict["data"] as? NSDictionary {
                        profileImageURL = pictureData["url"] as? String
                    }
                }
                NSUserDefaults.standardUserDefaults().setValue(firstName, forKey: KEY_FIRST_NAME)
                NSUserDefaults.standardUserDefaults().setValue(lastName, forKey: KEY_LAST_NAME)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let urlString = profileImageURL
                    if let url = NSURL(string: urlString!), data = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue(), {
                            if let profileImage = UIImage(data: data), profileImageData = UIImagePNGRepresentation(profileImage) {
                                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                                let destinationPath = documentsPath.stringByAppendingPathComponent("profileImage.png")
                                do {
                                    try profileImageData.writeToFile(destinationPath, options: .AtomicWrite)
                                } catch {
                                    print("error")
                                }
                            }
                        });
                    }
                }
            }
        })
    }
}
