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
    var invitedFriends : [String] = []
    var selectedFriends : [String] = []
    var currentInviteFriendIndexPath : NSIndexPath?
    
    let indexTitles = ["★","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","✉︎"];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        var cell : FriendCell = FriendCell()
        var name : String = ""
        switch (self.tableView(tableView, titleForHeaderInSection: indexPath.section)!) {
        case kSectionTitleRecents:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierScavenge, forIndexPath: indexPath) as! ScavengeFriendCell
            name = sampleRecents[indexPath.row]
            cell.nameLabel.text = name
            if (selectedFriends.indexOf(name) != nil) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            break
        case kSectionTitleFriendsOnScavenge:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierScavenge, forIndexPath: indexPath) as! ScavengeFriendCell
            name = sampleScavengeFriends[indexPath.row]
            cell.nameLabel.text = name
            if (selectedFriends.indexOf(name) != nil) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            break
        case kSectionTitleFriendsNotOnScavenge:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierFacebook, forIndexPath: indexPath) as! FacebookFriendCell
            name = sampleFacebookFriends[indexPath.row]
            cell.nameLabel.text = name
            if (invitedFriends.indexOf(name) != nil) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            break
        default:
            return cell
        }
        return cell
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
            if let index = selectedFriends.indexOf(friendForIndexPath(indexPath)) {
                selectedFriends.removeAtIndex(index)
            } else {
                selectedFriends.append(friendForIndexPath(indexPath))
            }
        } else {
            self.currentInviteFriendIndexPath = indexPath
            self.inviteFriend()
            invitedFriends.append(friendForIndexPath(indexPath))
        }
        tableView.reloadData()
    }

    
    // MARK: - UITextFieldDelegate
    
    // MARK: - MessageComposeViewControllerDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        switch (result.rawValue) {
        case MessageComposeResultSent.rawValue:
            if let indexPath = self.currentInviteFriendIndexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! FacebookFriendCell
                cell.setSelectedAppearance()
            }
            break
        case MessageComposeResultCancelled.rawValue:
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

}
