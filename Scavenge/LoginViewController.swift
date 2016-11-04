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
    
    @IBAction func fbLoginButtonPressed (_ sender: UIButton!) {
        self.attemptLoginWithFacebook()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.handleLoggedIn()
        }
    }

    func attemptLoginWithFacebook() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "user_friends"], from: self, handler: { (fbResult, error) ->
            Void in
            if (error != nil) {
                self.handleLoginError()
                print("Facebook login failed. Error \(error)")
            } else if fbResult!.isCancelled {
                print("cancelled")
            } else {
                print("Successfully logged into Facebook.")
                let accessToken = FBSDKAccessToken.current().tokenString
                UserDefaults.standard.setValue(accessToken, forKey: KEY_UID)
                self.getFacebookUserData()
            }
        })
    }
    
    func handleLoginError() {
        let alertController = UIAlertController(title: kErrorTitle, message: "There was an error logging into Facebook. Please try again.", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (alert) in
            self.attemptLoginWithFacebook()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleLoggedIn() {
        let mainStoryboard = UIStoryboard(name: kMainStoryboard, bundle: nil)
        let myScavengesViewController = mainStoryboard.instantiateInitialViewController()
        self.present(myScavengesViewController!, animated: true, completion: nil)
    }
    
    
    func getFacebookUserData() {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error != nil) {
                print("Error: \(error)")
            } else {
                guard let result = result as? [String:AnyObject],
                    let firstName = result["first_name"],
                    let lastName = result["last_name"]
                else {
                    return
                }
                var profileImageURL : String?
                if let profileImageDict = result["picture"] as? NSDictionary {
                    if let pictureData = profileImageDict["data"] as? NSDictionary {
                        profileImageURL = pictureData["url"] as? String
                    }
                }
                UserDefaults.standard.setValue(firstName, forKey: KEY_FIRST_NAME)
                UserDefaults.standard.setValue(lastName, forKey: KEY_LAST_NAME)
                
                DispatchQueue.global(qos: .default).async {
                    let urlString = profileImageURL
                    if let url = URL(string: urlString!), let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async(execute: {
                            if let profileImage = UIImage(data: data), let profileImageData = UIImagePNGRepresentation(profileImage) {
                                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                                let destinationPath = documentsPath.appendingPathComponent("profileImage.png")
                                do {
                                    try profileImageData.write(to: URL(fileURLWithPath: destinationPath), options: .atomicWrite)
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
