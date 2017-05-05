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
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var fbLoginButton: LoginButton!
    @IBAction func fbLoginButtonPressed (_ sender: UIButton!) {
        self.attemptLoginWithFacebook()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_ID) != nil && UserDefaults.standard.value(forKey: KEY_ACCESS_TOKEN) != nil {
            currentUserID = UserDefaults.standard.value(forKey: KEY_ID) as! String
            currentUserAccessToken = UserDefaults.standard.value(forKey: KEY_ACCESS_TOKEN) as! String
            self.handleLoggedIn(id: currentUserID, accessToken: currentUserAccessToken)
        } else {
            fbLoginButton.isHidden = false
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
                currentUserAccessToken = FBSDKAccessToken.current().tokenString
                print("access token: ", currentUserAccessToken)
                UserDefaults.standard.setValue(currentUserAccessToken, forKey: KEY_ACCESS_TOKEN)
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
    
    func handleLoggedIn(id: String, accessToken: String) {
        print("id: ", id)
        print("access token: ", accessToken)
        // TODO TODO TODO: uncomment this (temporarily not calling backend)
        let request = RegisterFacebookRequest(facebook_id: id, facebook_token: accessToken)
        request.completionBlock = { (response: JSON?, error: Any?) -> Void in
            if let json = response {
                if let accessToken = json["accessToken"].string {
                    currentUserAccessToken = accessToken
                    let mainStoryboard = UIStoryboard(name: kMainStoryboard, bundle: nil)
                    let homeViewController = mainStoryboard.instantiateInitialViewController()
                    self.present(homeViewController!, animated: true, completion: nil)
                }
            }
        }
        request.execute()
    }
    
    
    func getFacebookUserData() {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error != nil) {
                print("Error: \(error)")
            } else {
                guard let result = result as? [String:AnyObject],
                    let firstName = result["first_name"],
                    let lastName = result["last_name"],
                    let facebookID = result["id"] as? String
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
                UserDefaults.standard.setValue(facebookID, forKey: KEY_ID)
                
                currentUserID = facebookID
                
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
