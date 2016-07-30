//
//  NewGameViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/21/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import MessageUI

//let sampleRecents = ["Kim Seltzer", "Aliya Kamalova", "Carrie Bradshaw"]
let sampleRecents : [ScavengeFriend] = [
    ScavengeFriend(name: "Kim Seltzer", id: "1", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Kim", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Aliya Kamalova", id: "2", profileImage: UIImage(named: "aliya")!, firstName: "Aliya", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Charlie Bucket", id: "3", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Charlie", addedToGame: false, headerIndex: nil)
]

let sampleRecentsIDs = ["1", "2", "3"]
let sampleScavengeFriendIDs = ["4","5","6","7","8"]
let sampleFacebookFriendIDs = ["9","10"]

//let sampleScavengeFriends = ["Charlotte York", "Olivia Rothschild", "Paul Goetz", "David Seltzer", "Sachin Medhekar"]
let sampleScavengeFriends : [ScavengeFriend] = [
    ScavengeFriend(name: "Charlotte York", id: "4", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Charlotte", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Olivia Rothschild", id: "5", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Olivia", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Paul Goetz", id: "6", profileImage: UIImage(named: "paul")!, firstName: "Paul", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "David Seltzer", id: "7", profileImage: UIImage(named: "fbProfilePic")!, firstName: "David", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Sachin Medhekar", id: "8", profileImage: UIImage(named: "sachin")!, firstName: "Sachin", addedToGame: false, headerIndex: nil)
]

//let sampleFacebookFriends = ["Mahir Shah", "Ian Abramson", "Jenny Seltzer", "Ryan Pigg", "Katherine Leon"]
let sampleFacebookFriends : [FacebookFriend] = [
    FacebookFriend(name: "Mahir Shah", id: "9", profileImage: UIImage(named: "fbProfilePic")!, invited: false),
    FacebookFriend(name: "Ian Abramson", id: "10", profileImage: UIImage(named: "fbProfilePic")!, invited: false)
]

let recentsDictionaryFromAPI : [String:ScavengeFriend] = [
    "1":ScavengeFriend(name: "Kim Seltzer", id: "1", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Kim", addedToGame: false, headerIndex: nil),
    "2":ScavengeFriend(name: "Aliya Kamalova", id: "2", profileImage: UIImage(named: "aliya")!, firstName: "Aliya", addedToGame: false, headerIndex: nil),
    "3":ScavengeFriend(name: "Charlie Bucket", id: "3", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Charlie", addedToGame: false, headerIndex: nil)
]

var recentsDictionary = recentsDictionaryFromAPI

let scavengeDictionaryFromAPI : [String:ScavengeFriend] = [
    "4":ScavengeFriend(name: "Charlotte York", id: "4", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Charlotte", addedToGame: false, headerIndex: nil),
    "5":ScavengeFriend(name: "Olivia Rothschild", id: "5", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Olivia", addedToGame: false, headerIndex: nil),
    "6": ScavengeFriend(name: "Paul Goetz", id: "6", profileImage: UIImage(named: "paul")!, firstName: "Paul", addedToGame: false, headerIndex: nil),
    "7": ScavengeFriend(name: "David Seltzer", id: "7", profileImage: UIImage(named: "fbProfilePic")!, firstName: "David", addedToGame: false, headerIndex: nil),
    "8": ScavengeFriend(name: "Sachin Medhekar", id: "8", profileImage: UIImage(named: "sachin")!, firstName: "Sachin", addedToGame: false, headerIndex: nil)
]

var scavengeDictionary = scavengeDictionaryFromAPI

let fbFriendDictionaryFromAPI : [String:FacebookFriend] = [
    "9":FacebookFriend(name: "Mahir Shah", id: "9", profileImage: UIImage(named: "fbProfilePic")!, invited: false),
    "10":FacebookFriend(name: "Ian Abramson", id: "10", profileImage: UIImage(named: "fbProfilePic")!, invited: false)
]

var fbFriendDictionary = fbFriendDictionaryFromAPI

let smsInviteBody: String = "Hey! Long time no talk hahaha :) no but seriously I found this really fun app called Scavenge. Kind of a stupid name but it's actually a good game. You should download it so we can play."

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startButton: SButton!
    
    @IBOutlet weak var profileImageViewUser: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend1: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend2: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend3: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend4: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend5: ProfileImageView!
    
    var selectedFriendsIndices : [Int] = [5, 4, 3, 2, 1]
    var selectedFacebookFriendCell : FacebookFriendCell?
    var selectedFacebookFriend : FacebookFriend?
    
    var filteredRecents : [ScavengeFriend] = []
    var filteredScavengeFriends : [ScavengeFriend] = []
    var filteredFacebookFriends : [FacebookFriend] = []
    
    var filteredRecentsIDs : [String] = []
    var filteredScavengeFriendsIDs : [String] = []
    var filteredFacebookFriendsIDs : [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let indexTitles = ["★","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","✉︎"];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        startButton.enabled = false
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    // MARK: - Table View Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (self.tableView(tableView, titleForHeaderInSection: section)!) {
        case kSectionTitleRecents:
            if (searchController.active) {
                return filteredRecentsIDs.count
            }
            return sampleRecentsIDs.count
        case kSectionTitleFriendsOnScavenge:
            if (searchController.active) {
                return filteredScavengeFriendsIDs.count
            }
            return sampleScavengeFriendIDs.count
        case kSectionTitleFriendsNotOnScavenge:
            if (searchController.active) {
                return filteredFacebookFriendsIDs.count
            }
            return sampleFacebookFriendIDs.count
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
        var cell : FriendCell = FriendCell()
        var scavengeFriend : ScavengeFriend
        var facebookFriend : FacebookFriend
        var friend : Friend
        switch (section) {
        case kSectionTitleRecents:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierScavenge, forIndexPath: indexPath) as! ScavengeFriendCell
            if searchController.active && searchController.searchBar.text != "" {
                let id = filteredRecentsIDs[indexPath.row]
                scavengeFriend = recentsDictionary[id]!
            } else {
                scavengeFriend = recentsDictionary[sampleRecentsIDs[indexPath.row]]!
            }
            if (scavengeFriend.addedToGame) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            friend = scavengeFriend
            break
        case kSectionTitleFriendsOnScavenge:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierScavenge, forIndexPath: indexPath) as! ScavengeFriendCell
            if searchController.active && searchController.searchBar.text != "" {
                let id = filteredScavengeFriendsIDs[indexPath.row]
                scavengeFriend = scavengeDictionary[id]!
            } else {
                scavengeFriend = scavengeDictionary[sampleScavengeFriendIDs[indexPath.row]]!
            }
            if (scavengeFriend.addedToGame) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            friend = scavengeFriend
            break
        case kSectionTitleFriendsNotOnScavenge:
            cell = tableView.dequeueReusableCellWithIdentifier(kFriendCellIdentifierFacebook, forIndexPath: indexPath) as! FacebookFriendCell
            if searchController.active && searchController.searchBar.text != "" {
                let id = filteredFacebookFriendsIDs[indexPath.row]
                facebookFriend = fbFriendDictionary[id]!
            } else {
                facebookFriend = fbFriendDictionary[sampleFacebookFriendIDs[indexPath.row]]!
            }
            if (facebookFriend.invited) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            friend = facebookFriend
            break
        default:
            return cell
        }
        cell.userID = friend.id
        cell.nameLabel.text = friend.name
        cell.profileImage.image = friend.profileImage
        return cell
    }
    
    func handleAddRemoveFriend(friend : ScavengeFriend) -> ScavengeFriend? {
        var scavengeFriend = friend
        if scavengeFriend.addedToGame {                                                                     // remove friend
            selectedFriendsIndices.append(scavengeFriend.headerIndex!)
            self.removeSelectedFriendImageFromHeader(scavengeFriend.headerIndex!)
            scavengeFriend.addedToGame = false
        } else if (selectedFriendsIndices.count == 0) {                                                     // maximum friends added alert
            let alertController = UIAlertController(title: kErrorTitle, message: "You cannot have more than 6 players in a game. Remove one of your selected friends if you wanna add this lil guy", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK, My Bad", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return nil
        } else {                                                                                            // add friend
            selectedFriendsIndices = selectedFriendsIndices.sort().reverse()
            let headerIndex = selectedFriendsIndices.popLast()
            scavengeFriend.headerIndex = headerIndex
            scavengeFriend.addedToGame = true
            self.addSelectedFriendImageToHeader(scavengeFriend.profileImage, index: headerIndex)
        }
        return scavengeFriend
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var scavengeFriend : ScavengeFriend
        if (indexPath.section == 0 || indexPath.section == 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ScavengeFriendCell
            if (indexPath.section == 0) {
                scavengeFriend = recentsDictionary[cell.userID]!
                if let updatedFriend = handleAddRemoveFriend(scavengeFriend) {
                    recentsDictionary[scavengeFriend.id] = updatedFriend
                }
            } else if (indexPath.section == 1) {
                scavengeFriend = scavengeDictionary[cell.userID]!
                if let updatedFriend = handleAddRemoveFriend(scavengeFriend) {
                    scavengeDictionary[scavengeFriend.id] = updatedFriend
                }
            }
        }
        else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! FacebookFriendCell
            self.selectedFacebookFriend = fbFriendDictionary[cell.userID]!
            self.inviteFriend()
        }
        
        if (selectedFriendsIndices.count <= 3) {
            startButton.enabled = true
            startButton.alpha = 1.0
        } else {
            startButton.enabled = false
            startButton.alpha = 0.6
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
                selectedFacebookFriend!.invited = true
                fbFriendDictionary[friend.id] = selectedFacebookFriend!
            }
//            selectedFacebookFriendCell?.setDeselectedAppearance()
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
    
    // MARK: - UISearchResultsUpdating Protocol
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func filterContentForSearchText(searchText: String) {
        filteredRecentsIDs = []
        filteredRecents = recentsDictionary.values.filter { friend in
            return friend.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        for friend in filteredRecents {
            filteredRecentsIDs.append(friend.id)
        }
    
        filteredScavengeFriendsIDs = []
        filteredScavengeFriends = scavengeDictionary.values.filter { friend in
            return friend.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        for friend in filteredScavengeFriends {
            filteredScavengeFriendsIDs.append(friend.id)
        }
        
        filteredFacebookFriendsIDs = []
        filteredFacebookFriends = fbFriendDictionary.values.filter { friend in
            return friend.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        for friend in filteredFacebookFriends {
            filteredFacebookFriendsIDs.append(friend.id)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    
    // MARK: - Segue
    @IBAction func startButtonTapped(sender: SButton) {
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
        self.navigationController?.presentViewController(playingGameViewController!, animated: true, completion: nil)
    }
    

}
