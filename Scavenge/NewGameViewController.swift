//
//  NewGameViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/21/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import MessageUI

let sampleRecents = ["Kim Seltzer", "Aliya Kamalova", "Carrie Bradshaw"]
let sampleScavengeFriends = ["Charlotte York", "Olivia Rothschild", "Paul Goetz", "David Seltzer", "Sachin Medhekar"]
let sampleFacebookFriends = ["Mahir Shah", "Ian Abramson", "Jenny Seltzer", "Ryan Pigg", "Katherine Leon"]

let smsInviteBody: String = "Hey! Long time no talk hahaha :) no but seriously I found this really fun app called Scavenge. Kind of a stupid name but it's actually a good game. You should download it so we can play."

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startButton: SButton!
    
    @IBOutlet weak var profileImageViewUser: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend1: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend2: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend3: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend4: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend5: ProfileImageView!
    
    
    
    var invitedFriends : [String] = []
    var selectedFriends : [String] = []
    var selectedFriendsIndices : [Int] = [5, 4, 3, 2, 1]
    var selectedFacebookFriendCell : FacebookFriendCell?
    var selectedFacebookFriend : String?
    
    let indexTitles = ["★","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","✉︎"];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        startButton.enabled = false
    }
    
    // MARK: - Table View Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (self.tableView(tableView, titleForHeaderInSection: section)!) {
        case kSectionTitleRecents:
            return sampleRecents.count
        case kSectionTitleFriendsOnScavenge:
            return sampleScavengeFriends.count
        case kSectionTitleFriendsNotOnScavenge:
            return sampleFacebookFriends.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return kSectionTitleRecents
        case 1:
            return kSectionTitleFriendsOnScavenge
        case 2:
            return kSectionTitleFriendsNotOnScavenge
        default:
            return nil
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        switch (title) {
        case "★":
            return 0
        case "✉︎":
            return 2
        default:
            return 1
        }
    }
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
//        header.contentView.backgroundColor = UIColor.whiteColor()
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle = "Default"
        switch (section) {
        case 0:
            sectionTitle = kSectionTitleRecents
            break
        case 1:
            sectionTitle = kSectionTitleFriendsOnScavenge
            break
        case 2:
            sectionTitle = kSectionTitleFriendsNotOnScavenge
            break
        default:
            break
        }
        
        let returnedView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 22))
        returnedView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(8, 0, tableView.frame.width, 22))
        label.text = sectionTitle
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.configureCell(indexPath, section: self.tableView(tableView, titleForHeaderInSection: indexPath.section)!)
    }
    
    func configureCell(indexPath: NSIndexPath, section: String) -> FriendCell {
        var cell: FriendCell = FriendCell()
        var name: String = ""
        switch (section) {
        case kSectionTitleRecents:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierScavenge, forIndexPath: indexPath) as! ScavengeFriendCell
            name = sampleRecents[indexPath.row]
            cell.nameLabel.text = name
            if (selectedFriends.indexOf(name) != nil) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            return cell
        case kSectionTitleFriendsOnScavenge:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierScavenge, forIndexPath: indexPath) as! ScavengeFriendCell
            name = sampleScavengeFriends[indexPath.row]
            cell.nameLabel.text = name
            if (selectedFriends.indexOf(name) != nil) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            return cell
        case kSectionTitleFriendsNotOnScavenge:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierFacebook, forIndexPath: indexPath) as! FacebookFriendCell
            name = sampleFacebookFriends[indexPath.row]
            cell.nameLabel.text = name
            if (invitedFriends.indexOf(name) != nil) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            return cell
        default:
            return cell
        }
    }
    
    func friendForIndexPath(indexPath: NSIndexPath) -> String {
        var name : String = ""
        switch (self.tableView(tableView, titleForHeaderInSection: indexPath.section)!) {
        case kSectionTitleRecents:
            name = sampleRecents[indexPath.row]
        case kSectionTitleFriendsOnScavenge:
            name = sampleScavengeFriends[indexPath.row]
        case kSectionTitleFriendsNotOnScavenge:
            name = sampleFacebookFriends[indexPath.row]
        default:
            break
        }
        return name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0 || indexPath.section == 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ScavengeFriendCell
            if let headerIndex = cell.headerProfilePhotoIndex, selectedFriendsIndex = selectedFriends.indexOf(friendForIndexPath(indexPath)) {
                selectedFriendsIndices.append(headerIndex)
                self.removeSelectedFriendImageFromHeader(headerIndex)
                selectedFriends.removeAtIndex(selectedFriendsIndex)
            } else if selectedFriends.count == 5 {
                let alertController = UIAlertController(title: kErrorTitle, message: "You cannot have more than 6 players in a game. Remove one of your selected friends if you wanna add this lil guy", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK, My Bad", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            } else {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ScavengeFriendCell
                let index = selectedFriendsIndices.popLast()
                cell.headerProfilePhotoIndex = index
                selectedFriends.append(cell.nameLabel.text!)
//                self.addSelectedFriendImageToHeader(cell.profileImage.image, index: index)
                self.addSelectedFriendImageToHeader(UIImage(named: "fbProfilePic"), index: index)
            }
        } else {
            self.selectedFacebookFriendCell = tableView.cellForRowAtIndexPath(indexPath) as? FacebookFriendCell
            self.selectedFacebookFriend = friendForIndexPath(indexPath)
            self.inviteFriend()
        }
        if (selectedFriends.count >= 2 && selectedFriends.count <= 6) {
            startButton.enabled = true
            startButton.alpha = 1.0
        } else {
            startButton.enabled = false
            startButton.alpha = 0.5
        }
        tableView.reloadData()
    }
    
    func addSelectedFriendImageToHeader(profileImage: UIImage?, index: Int?) {
        if let image = profileImage, headerProfilePhotoIndex = index {
            switch (headerProfilePhotoIndex) {
            case 1:
                profileImageViewFriend1.image = image
                break
            case 2:
                profileImageViewFriend2.image = image
                break
            case 3:
                profileImageViewFriend3.image = image
                break
            case 4:
                profileImageViewFriend4.image = image
                break
            case 5:
                profileImageViewFriend5.image = image
                break
            default:
                break
            }
        }
    }
    
    func removeSelectedFriendImageFromHeader(index: Int?) {
        if let headerProfilePhotoIndex = index {
            switch (headerProfilePhotoIndex) {
            case 1:
                profileImageViewFriend1.image = UIImage(named: "profilePicNegativeState")
                break
            case 2:
                profileImageViewFriend2.image = UIImage(named: "profilePicNegativeState")
                break
            case 3:
                profileImageViewFriend3.image = UIImage(named: "profilePicNegativeState")
                break
            case 4:
                profileImageViewFriend4.image = UIImage(named: "profilePicNegativeState")
                break
            case 5:
                profileImageViewFriend5.image = UIImage(named: "profilePicNegativeState")
                break
            default:
                break
            }
        }
    }

    
    // MARK: - UITextFieldDelegate
    
    // MARK: - MessageComposeViewControllerDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        switch (result.rawValue) {
        case MessageComposeResultSent.rawValue:
            if let friend = selectedFacebookFriend {
                invitedFriends.append(friend)
            }
            selectedFacebookFriendCell?.setDeselectedAppearance()
            break
        case MessageComposeResultCancelled.rawValue:
            selectedFacebookFriendCell?.setDeselectedAppearance()
            break
        case MessageComposeResultFailed.rawValue:
            let alertController = UIAlertController(title: kErrorTitle, message: "Message Failed :/", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "Ugh, OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
        tableView.reloadData()
        selectedFacebookFriendCell = nil
        selectedFacebookFriend = nil
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func inviteFriend() {
        if !MFMessageComposeViewController.canSendText() {
            let alertController = UIAlertController(title: kErrorTitle, message: kSMSFailureMessage, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: kAcceptFaultErrorMessage, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = []
            composeVC.body = smsInviteBody
            self.presentViewController(composeVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Search Controller
    func presentSearchController(searchController: UISearchController) {
        print("present search controller")
    }
    
    // MARK: - Segue
    @IBAction func startButtonTapped(sender: SButton) {
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
        self.navigationController?.presentViewController(playingGameViewController!, animated: true, completion: nil)
    }
    

}
