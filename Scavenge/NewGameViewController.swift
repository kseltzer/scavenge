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
let cannotAddAdditionalPlayersMessage = "ya can't have more than \(MAX_PLAYERS) players\nin a game"

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBarView: UIView!
    
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
    var selectedIndexPaths : [IndexPath] = []
    
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

        startButton.isEnabled = false
        
        setupSearchController()
        
        navigationItem.backBarButtonItem = customBackBarItem()
        
        titleTextField.delegate = self
        titleTextField.placeholder = gameTitle
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchBarView.addSubview(searchController.searchBar)
        searchController.loadViewIfNeeded()
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        do something with gameTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (self.tableView(tableView, titleForHeaderInSection: section)!) {
        case kSectionTitleRecents:
            if (searchController.isActive && searchController.searchBar.text != "") {
                return filteredRecentsIDs.count
            }
            return sampleRecentsIDs.count
        case kSectionTitleFriendsOnScavenge:
            if (searchController.isActive && searchController.searchBar.text != "") {
                return filteredScavengeFriendsIDs.count
            }
            return sampleScavengeFriendIDs.count
        case kSectionTitleFriendsNotOnScavenge:
            if (searchController.isActive && searchController.searchBar.text != "") {
                return filteredFacebookFriendsIDs.count
            }
            return sampleFacebookFriendIDs.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        returnedView.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 8, y: topPadding, width: tableView.frame.width, height: 22))
        label.text = sectionTitle
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isInitialCellConfiguration) {
            return self.configureCellInitially(indexPath, section: self.tableView(tableView, titleForHeaderInSection: (indexPath as NSIndexPath).section)!)
        } else {
            return self.configureCell(indexPath, section: self.tableView(tableView, titleForHeaderInSection: (indexPath as NSIndexPath).section)!)
        }
    }
    
    func configureCellInitially(_ indexPath: IndexPath, section: String) -> FriendCell {
        var cell : FriendCell = FriendCell()
        var scavengeFriend : ScavengeFriend
        var facebookFriend : FacebookFriend
        var friend : Friend
        switch (section) {
        case kSectionTitleRecents:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifierScavenge, for: indexPath) as! ScavengeFriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredRecentsIDs[(indexPath as NSIndexPath).row]
                scavengeFriend = recentsDictionary[id]!
            } else {
                scavengeFriend = recentsDictionary[sampleRecentsIDs[(indexPath as NSIndexPath).row]]!
            }
            scavengeFriend.addedToGame = false
            recentsDictionary[scavengeFriend.id] = scavengeFriend
            friend = scavengeFriend
            break
        case kSectionTitleFriendsOnScavenge:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifierScavenge, for: indexPath) as! ScavengeFriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredScavengeFriendsIDs[(indexPath as NSIndexPath).row]
                scavengeFriend = scavengeDictionary[id]!
            } else {
                scavengeFriend = scavengeDictionary[sampleScavengeFriendIDs[(indexPath as NSIndexPath).row]]!
            }
            scavengeFriend.addedToGame = false
            scavengeDictionary[scavengeFriend.id] = scavengeFriend
            friend = scavengeFriend
            break
        case kSectionTitleFriendsNotOnScavenge:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifierFacebook, for: indexPath) as! FacebookFriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredFacebookFriendsIDs[(indexPath as NSIndexPath).row]
                facebookFriend = fbFriendDictionary[id]!
            } else {
                facebookFriend = fbFriendDictionary[sampleFacebookFriendIDs[(indexPath as NSIndexPath).row]]!
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
    
    func configureCell(_ indexPath: IndexPath, section: String) -> FriendCell {
        var cell : FriendCell = FriendCell()
        var scavengeFriend : ScavengeFriend
        var facebookFriend : FacebookFriend
        var friend : Friend
        switch (section) {
        case kSectionTitleRecents:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifierScavenge, for: indexPath) as! ScavengeFriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredRecentsIDs[(indexPath as NSIndexPath).row]
                scavengeFriend = recentsDictionary[id]!
            } else {
                scavengeFriend = recentsDictionary[sampleRecentsIDs[(indexPath as NSIndexPath).row]]!
            }
            if (scavengeFriend.addedToGame) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            friend = scavengeFriend
            break
        case kSectionTitleFriendsOnScavenge:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifierScavenge, for: indexPath) as! ScavengeFriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredScavengeFriendsIDs[(indexPath as NSIndexPath).row]
                scavengeFriend = scavengeDictionary[id]!
            } else {
                scavengeFriend = scavengeDictionary[sampleScavengeFriendIDs[(indexPath as NSIndexPath).row]]!
            }
            if (scavengeFriend.addedToGame) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            friend = scavengeFriend
            break
        case kSectionTitleFriendsNotOnScavenge:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifierFacebook, for: indexPath) as! FacebookFriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredFacebookFriendsIDs[(indexPath as NSIndexPath).row]
                facebookFriend = fbFriendDictionary[id]!
            } else {
                facebookFriend = fbFriendDictionary[sampleFacebookFriendIDs[(indexPath as NSIndexPath).row]]!
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
    
    func handleAddRemoveFriend(_ friend : ScavengeFriend, indexPath : IndexPath) -> ScavengeFriend? {
        var scavengeFriend = friend
        if scavengeFriend.addedToGame {                                                     // remove friend
            selectedFriendsHeaderIndices.append(scavengeFriend.headerIndex!)
            self.removeSelectedFriendImageFromHeader(scavengeFriend.headerIndex!)
            scavengeFriend.addedToGame = false
            if let indexOfIndexPath = selectedIndexPaths.index(of: indexPath) {
                selectedIndexPaths.remove(at: indexOfIndexPath)
            }
            if let indexOfFirstName = selectedFriendsFirstNames.index(of: scavengeFriend.firstName) {
                selectedFriendsFirstNames.remove(at: indexOfFirstName)
                if (selectedFriendsFirstNames.isEmpty) {
                    gameTitle = "Untitled Game"
                } else {
                    gameTitle = generateGameTitle()
                }
                titleTextField.placeholder = gameTitle
            }
        } else if (selectedFriendsHeaderIndices.count == 0) {                                     // maximum friends added alert
            let alertController = UIAlertController(title: kErrorTitle, message: cannotAddAdditionalPlayersMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAcceptFaultErrorMessage, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return nil
        } else {                                                                            // add friend
            selectedFriendsHeaderIndices = selectedFriendsHeaderIndices.sorted().reversed()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (titleTextField.isFirstResponder) {
            titleTextField.resignFirstResponder()
        }
        
        isInitialCellConfiguration = false
        
        var scavengeFriend : ScavengeFriend
        if ((indexPath as NSIndexPath).section == 0 || (indexPath as NSIndexPath).section == 1) {
            let cell = tableView.cellForRow(at: indexPath) as! ScavengeFriendCell
            if ((indexPath as NSIndexPath).section == 0) {
                scavengeFriend = recentsDictionary[cell.userID]!
                if let updatedFriend = handleAddRemoveFriend(scavengeFriend, indexPath: indexPath) {
                    recentsDictionary[scavengeFriend.id] = updatedFriend
                }
            } else if ((indexPath as NSIndexPath).section == 1) {
                scavengeFriend = scavengeDictionary[cell.userID]!
                if let updatedFriend = handleAddRemoveFriend(scavengeFriend, indexPath: indexPath) {
                    scavengeDictionary[scavengeFriend.id] = updatedFriend
                }
            }
        }
        else {
            let cell = tableView.cellForRow(at: indexPath) as! FacebookFriendCell
            self.selectedFacebookFriend = fbFriendDictionary[cell.userID]!
            self.inviteFriend()
        }
        
        if (selectedFriendsFirstNames.count >= 2) {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
        
        tableView.reloadData()
    }
    
    func addSelectedFriendImageToHeader(_ profileImage: UIImage?, index: Int?) {
        if let image = profileImage, let headerProfilePhotoIndex = index {
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
    
    func removeSelectedFriendImageFromHeader(_ index: Int?) {
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
        return selectedFriendsFirstNames.joined(separator: ", ")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = gameTitle
        tableView.isUserInteractionEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "Game Title"
        tableView.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        titleTextField.resignFirstResponder()
    }
    
    // MARK: - MessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        switch (result.rawValue) {
        case MessageComposeResult.sent.rawValue:
            if let friend = selectedFacebookFriend {
                selectedFacebookFriend!.invited = true
                fbFriendDictionary[friend.id] = selectedFacebookFriend!
            }
            break
        case MessageComposeResult.cancelled.rawValue:
            selectedFacebookFriendCell?.setDeselectedAppearance()
            break
        case MessageComposeResult.failed.rawValue:
            let alertController = UIAlertController(title: kErrorTitle, message: "Message Failed :/", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ugh, OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
        tableView.reloadData()
        selectedFacebookFriendCell = nil
        selectedFacebookFriend = nil
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    func inviteFriend() {
        if !MFMessageComposeViewController.canSendText() {
            let alertController = UIAlertController(title: kErrorTitle, message: kSMSFailureMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAcceptFaultErrorMessage, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = []
            composeVC.body = smsInviteBody
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - UISearchResultsUpdating Protocol
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredRecentsIDs = []
        filteredRecents = recentsDictionary.values.filter { friend in
            return friend.name.lowercased().contains(searchText.lowercased())
        }
        for friend in filteredRecents {
            filteredRecentsIDs.append(friend.id)
        }
    
        filteredScavengeFriendsIDs = []
        filteredScavengeFriends = scavengeDictionary.values.filter { friend in
            return friend.name.lowercased().contains(searchText.lowercased())
        }
        for friend in filteredScavengeFriends {
            filteredScavengeFriendsIDs.append(friend.id)
        }
        
        filteredFacebookFriendsIDs = []
        filteredFacebookFriends = fbFriendDictionary.values.filter { friend in
            return friend.name.lowercased().contains(searchText.lowercased())
        }
        for friend in filteredFacebookFriends {
            filteredFacebookFriendsIDs.append(friend.id)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Segue
    @IBAction func startButtonTapped(_ sender: UIBarButtonItem) {
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
        navigationController?.pushViewController(playingGameViewController!, animated: true)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.isInitialCellConfiguration = true
    }
}
