//
//  NewGameViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/21/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import MessageUI

let sampleRecents : [ScavengeFriend] = [
    ScavengeFriend(name: "Kim Seltzer", id: "1", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Kim", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Aliya Kamalova", id: "2", profileImage: UIImage(named: "aliya")!, firstName: "Aliya", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Charlie Bucket", id: "3", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Charlie", addedToGame: false, headerIndex: nil)
]

let sampleRecentsIDs = ["1", "2", "3"]
let sampleScavengeFriendIDs = ["4","5","6","7","8"]
let sampleFacebookFriendIDs = ["9","10"]

let sampleScavengeFriends : [ScavengeFriend] = [
    ScavengeFriend(name: "Charlotte York", id: "4", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Charlotte", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Olivia Rothschild", id: "5", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Olivia", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Paul Goetz", id: "6", profileImage: UIImage(named: "paul")!, firstName: "Paul", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "David Seltzer", id: "7", profileImage: UIImage(named: "fbProfilePic")!, firstName: "David", addedToGame: false, headerIndex: nil),
    ScavengeFriend(name: "Sachin Medhekar", id: "8", profileImage: UIImage(named: "sachin")!, firstName: "Sachin", addedToGame: false, headerIndex: nil)
]

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
let cannotAddAdditionalPlayersMessage = "ya can't have more than 6 players\nin a game"

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
    
    var selectedFriendsHeaderIndices : [Int] = [5, 4, 3, 2, 1]
    var selectedFriendsFirstNames : [String] = []
    var selectedFacebookFriendCell : FacebookFriendCell?
    var selectedFacebookFriend : FacebookFriend?
    var selectedIndexPaths : [NSIndexPath] = []
    
    var filteredRecents : [ScavengeFriend] = []
    var filteredScavengeFriends : [ScavengeFriend] = []
    var filteredFacebookFriends : [FacebookFriend] = []
    
    var filteredRecentsIDs : [String] = []
    var filteredScavengeFriendsIDs : [String] = []
    var filteredFacebookFriendsIDs : [String] = []
    
    var gameTitle : String = "Untitled Game"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isInitialCellConfiguration : Bool = true

//    let indexTitles = ["★","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","✉︎"];

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
        searchController.loadViewIfNeeded()
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.backBarButtonItem = customBackBarItem()
        
        titleTextField.delegate = self
        titleTextField.placeholder = gameTitle
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        print(gameTitle)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (isInitialCellConfiguration) {
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (self.tableView(tableView, titleForHeaderInSection: section)!) {
        case kSectionTitleRecents:
            if (searchController.active && searchController.searchBar.text != "") {
                return filteredRecentsIDs.count
            }
            return sampleRecentsIDs.count
        case kSectionTitleFriendsOnScavenge:
            if (searchController.active && searchController.searchBar.text != "") {
                return filteredScavengeFriendsIDs.count
            }
            return sampleScavengeFriendIDs.count
        case kSectionTitleFriendsNotOnScavenge:
            if (searchController.active && searchController.searchBar.text != "") {
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
    
    ////////////////////////////////////////////////////
    /////// Uncomment for alphabetical indexing ////////
    ////////////////////////////////////////////////////
    /*
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
     */
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle = "Default"
        var topPadding : CGFloat!
        switch (section) {
        case 0:
            sectionTitle = kSectionTitleRecents
            topPadding = 3
            break
        case 1:
            sectionTitle = kSectionTitleFriendsOnScavenge
            topPadding = 0
            break
        case 2:
            sectionTitle = kSectionTitleFriendsNotOnScavenge
            topPadding = 0
            break
        default:
            break
        }
        
        let returnedView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 35))
        returnedView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(8, topPadding, tableView.frame.width, 22))
        label.text = sectionTitle
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (isInitialCellConfiguration) {
            return self.configureCellInitially(indexPath, section: self.tableView(tableView, titleForHeaderInSection: indexPath.section)!)
        } else {
            return self.configureCell(indexPath, section: self.tableView(tableView, titleForHeaderInSection: indexPath.section)!)
        }
    }
    
    func configureCellInitially(indexPath: NSIndexPath, section: String) -> FriendCell {
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
            scavengeFriend.addedToGame = false
            recentsDictionary[scavengeFriend.id] = scavengeFriend
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
            scavengeFriend.addedToGame = false
            scavengeDictionary[scavengeFriend.id] = scavengeFriend
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
            facebookFriend.invited = false
            fbFriendDictionary[facebookFriend.id] = facebookFriend
            friend = facebookFriend
            break
        default:
            return cell
        }
        cell.userID = friend.id
        cell.nameLabel.text = friend.name
        cell.profileImage.image = friend.profileImage
        cell.setDeselectedAppearance()
        return cell
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
    
    func handleAddRemoveFriend(friend : ScavengeFriend, indexPath : NSIndexPath) -> ScavengeFriend? {
        var scavengeFriend = friend
        if scavengeFriend.addedToGame {                                                     // remove friend
            selectedFriendsHeaderIndices.append(scavengeFriend.headerIndex!)
            self.removeSelectedFriendImageFromHeader(scavengeFriend.headerIndex!)
            scavengeFriend.addedToGame = false
            if let indexOfIndexPath = selectedIndexPaths.indexOf(indexPath) {
                selectedIndexPaths.removeAtIndex(indexOfIndexPath)
            }
            if let indexOfFirstName = selectedFriendsFirstNames.indexOf(scavengeFriend.firstName) {
                selectedFriendsFirstNames.removeAtIndex(indexOfFirstName)
                if (selectedFriendsFirstNames.isEmpty) {
                    gameTitle = "Untitled Game"
                } else {
                    gameTitle = generateGameTitle()
                }
                titleTextField.placeholder = gameTitle
            }
        } else if (selectedFriendsHeaderIndices.count == 0) {                                     // maximum friends added alert
            let alertController = UIAlertController(title: kErrorTitle, message: cannotAddAdditionalPlayersMessage, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: kAcceptFaultErrorMessage, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return nil
        } else {                                                                            // add friend
            selectedFriendsHeaderIndices = selectedFriendsHeaderIndices.sort().reverse()
            let headerIndex = selectedFriendsHeaderIndices.popLast()
            scavengeFriend.headerIndex = headerIndex
            scavengeFriend.addedToGame = true
            self.addSelectedFriendImageToHeader(scavengeFriend.profileImage, index: headerIndex)
            selectedIndexPaths.append(indexPath)
            selectedFriendsFirstNames.append(scavengeFriend.firstName)
            gameTitle = generateGameTitle()
            titleTextField.placeholder = gameTitle
        }
        return scavengeFriend
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (titleTextField.isFirstResponder()) {
            titleTextField.resignFirstResponder()
        }
        
        isInitialCellConfiguration = false
        
        var scavengeFriend : ScavengeFriend
        if (indexPath.section == 0 || indexPath.section == 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ScavengeFriendCell
            if (indexPath.section == 0) {
                scavengeFriend = recentsDictionary[cell.userID]!
                if let updatedFriend = handleAddRemoveFriend(scavengeFriend, indexPath: indexPath) {
                    recentsDictionary[scavengeFriend.id] = updatedFriend
                }
            } else if (indexPath.section == 1) {
                scavengeFriend = scavengeDictionary[cell.userID]!
                if let updatedFriend = handleAddRemoveFriend(scavengeFriend, indexPath: indexPath) {
                    scavengeDictionary[scavengeFriend.id] = updatedFriend
                }
            }
        }
        else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! FacebookFriendCell
            self.selectedFacebookFriend = fbFriendDictionary[cell.userID]!
            self.inviteFriend()
        }
        
        if (selectedFriendsFirstNames.count >= 2) {
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
                profileImageViewFriend1.image = UIImage(named: "kimNegativeState")
                break
            case 2:
                profileImageViewFriend2.image = UIImage(named: "sachinNegativeState")
                break
            case 3:
                profileImageViewFriend3.image = UIImage(named: "kimNegativeState")
                break
            case 4:
                profileImageViewFriend4.image = UIImage(named: "sachinNegativeState")
                break
            case 5:
                profileImageViewFriend5.image = UIImage(named: "kimNegativeState")
                break
            default:
                break
            }
        }
    }

    
    // MARK: - UITextFieldDelegate
    func generateGameTitle() -> String {
        return selectedFriendsFirstNames.joinWithSeparator(", ")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.placeholder = gameTitle
        tableView.userInteractionEnabled = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = "Game Title"
        tableView.userInteractionEnabled = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        titleTextField.resignFirstResponder()
    }
    
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
    
    // MARK: - Segue
    @IBAction func startButtonTapped(sender: SButton) {
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
        navigationController?.pushViewController(playingGameViewController!, animated: true)
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        self.isInitialCellConfiguration = true
    }
}
