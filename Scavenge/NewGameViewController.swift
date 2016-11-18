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
    ScavengeFriend(name: "Kim Seltzer", id: "1", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Kim", addedToGame: false, headerIndex: nil, indexPath: nil),
    ScavengeFriend(name: "Aliya Kamalova", id: "2", profileImage: UIImage(named: "aliya")!, firstName: "Aliya", addedToGame: false, headerIndex: nil, indexPath: nil),
    ScavengeFriend(name: "Charlie Bucket", id: "3", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlie", addedToGame: false, headerIndex: nil, indexPath: nil)
]

let sampleRecentsIDs = ["1", "2", "3"]
let sampleScavengeFriendIDs = ["4","5","6","7","8"]

let sampleScavengeFriends : [ScavengeFriend] = [
    ScavengeFriend(name: "Charlotte York", id: "4", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlotte", addedToGame: false, headerIndex: nil, indexPath: nil),
    ScavengeFriend(name: "Olivia Rothschild", id: "5", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Olivia", addedToGame: false, headerIndex: nil, indexPath: nil),
    ScavengeFriend(name: "Paul Goetz", id: "6", profileImage: UIImage(named: "paul")!, firstName: "Paul", addedToGame: false, headerIndex: nil, indexPath: nil),
    ScavengeFriend(name: "David Seltzer", id: "7", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "David", addedToGame: false, headerIndex: nil, indexPath: nil),
    ScavengeFriend(name: "Sachin Medhekar", id: "8", profileImage: UIImage(named: "sachin")!, firstName: "Sachin", addedToGame: false, headerIndex: nil, indexPath: nil)
]

let recentsDictionaryFromAPI : [String:ScavengeFriend] = [
    "1":ScavengeFriend(name: "Kim Seltzer", id: "1", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Kim", addedToGame: false, headerIndex: nil, indexPath: nil),
    "2":ScavengeFriend(name: "Aliya Kamalova", id: "2", profileImage: UIImage(named: "aliya")!, firstName: "Aliya", addedToGame: false, headerIndex: nil, indexPath: nil),
    "3":ScavengeFriend(name: "Charlie Bucket", id: "3", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlie", addedToGame: false, headerIndex: nil, indexPath: nil)
]

var recentsDictionary = recentsDictionaryFromAPI

let scavengeDictionaryFromAPI : [String:ScavengeFriend] = [
    "4":ScavengeFriend(name: "Charlotte York", id: "4", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlotte", addedToGame: false, headerIndex: nil, indexPath: nil),
    "5":ScavengeFriend(name: "Olivia Rothschild", id: "5", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Olivia", addedToGame: false, headerIndex: nil, indexPath: nil),
    "6": ScavengeFriend(name: "Paul Goetz", id: "6", profileImage: UIImage(named: "paul")!, firstName: "Paul", addedToGame: false, headerIndex: nil, indexPath: nil),
    "7": ScavengeFriend(name: "David Seltzer", id: "7", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "David", addedToGame: false, headerIndex: nil, indexPath: nil),
    "8": ScavengeFriend(name: "Sachin Medhekar", id: "8", profileImage: UIImage(named: "sachin")!, firstName: "Sachin", addedToGame: false, headerIndex: nil, indexPath: nil)
]

var scavengeDictionary = scavengeDictionaryFromAPI

let smsInviteBody: String = "Hey! Long time no talk hahaha :) no but seriously I found this really fun app called Scavenge. Kind of a stupid name but it's actually a good game. You should download it so we can play."
let cannotAddAdditionalPlayersMessage = "ya can't have more than \(MAX_PLAYERS) players\nin a game"

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UISearchResultsUpdating, MagnifiedProfileImageViewDelegate {
    
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
    
    @IBOutlet weak var profileImagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var overlayView: UIView!
    
    var magnifiedPlayerName: String?
    var magnifiedPlayerImage: UIImage?
    var magnifiedPlayerIndex: Int?
    
    var selectedScavengeFriends : [ScavengeFriend?] = [nil, nil, nil, nil, nil]
    
    var selectedFriendsHeaderIndices : [Int] = [5, 4, 3, 2, 1]
    var selectedFriendsFirstNames : [String] = []
    var selectedIndexPaths : [IndexPath] = []
    
    var filteredRecents : [ScavengeFriend] = []
    var filteredScavengeFriends : [ScavengeFriend] = []
    
    var filteredRecentsIDs : [String] = []
    var filteredScavengeFriendsIDs : [String] = []
    
    var gameTitle : String = "Untitled Game"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isInitialCellConfiguration : Bool = true
    
    let interactor = InteractiveMenuTransition()

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
        
        let screenSize: CGRect = UIScreen.main.bounds
        switch (screenSize.width) {
        case iPHONE_6, iPHONE_6S, iPHONE_7, iPHONE_7S:
            profileImagesViewHeightConstraint.constant = 66.0
            break
        case iPHONE_SE, iPHONE_5, iPHONE_5S:
            profileImagesViewHeightConstraint.constant = 58.0
            profileImagesStackViewLeadingConstraint.constant = 4.0
            profileImagesStackViewTrailingConstraint.constant = 4.0
            profileImagesStackViewTopConstraint.constant = 6.0
            profileImagesStackViewBottomConstraint.constant = 6.0
            break
        case iPHONE_6_PLUS, iPHONE_7_PLUS:
            profileImagesViewHeightConstraint.constant = 68.0
            profileImagesStackViewLeadingConstraint.constant = 14.0
            profileImagesStackViewTrailingConstraint.constant = 14.0
            profileImagesStackViewTopConstraint.constant = 10.0
            profileImagesStackViewBottomConstraint.constant = 10.0
            break
        default:
            break
        }
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
            return 2
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
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                return tableView.dequeueReusableCell(withIdentifier: "inviteViaFacebookCell", for: indexPath) as! InviteViaFacebookCell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "inviteViaTextCell", for: indexPath) as! InviteViaTextCell
            }
        }
        if (isInitialCellConfiguration) {
            return self.configureCellInitially(indexPath, section: self.tableView(tableView, titleForHeaderInSection: (indexPath as NSIndexPath).section)!)
        } else {
            return self.configureCell(indexPath, section: self.tableView(tableView, titleForHeaderInSection: (indexPath as NSIndexPath).section)!)
        }
    }
    
    func configureCellInitially(_ indexPath: IndexPath, section: String) -> ScavengeFriendCell {
        var cell : ScavengeFriendCell = ScavengeFriendCell()
        var scavengeFriend : ScavengeFriend!
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
            break
        default:
            return cell
        }
        if (!(searchController.isActive && searchController.searchBar.text != nil)) {
            scavengeFriend.indexPath = indexPath
        }
        cell.userID = scavengeFriend.id
        cell.nameLabel.text = scavengeFriend.name
        cell.profileImage.layoutIfNeeded()
        cell.profileImage.circular()
        cell.profileImage.image = scavengeFriend.profileImage
        cell.setDeselectedAppearance()
        return cell
    }
    
    func configureCell(_ indexPath: IndexPath, section: String) -> ScavengeFriendCell {
        var cell : ScavengeFriendCell = ScavengeFriendCell()
        var scavengeFriend : ScavengeFriend!
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
            break
        default:
            return cell
        }
        if (!(searchController.isActive && searchController.searchBar.text != nil)) {
            scavengeFriend.indexPath = indexPath
        }
        cell.userID = scavengeFriend.id
        cell.nameLabel.text = scavengeFriend.name
        cell.profileImage.layoutIfNeeded()
        cell.profileImage.circular()
        cell.profileImage.image = scavengeFriend.profileImage
        return cell
    }
    
    @IBAction func tappedProfileImage(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            showMagnifiedProfileImage(index: tag-1)
        }
    }
    
    func showMagnifiedProfileImage(index: Int) {
        if (selectedScavengeFriends[index] != nil && !searchController.isActive) {
            magnifiedPlayerIndex = index
            overlayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            self.performSegue(withIdentifier: "showMagnifiedProfileImageView", sender: self)
        }
    }
    
    func handleAddRemoveFriend(_ friend : ScavengeFriend, indexPath : IndexPath?) -> ScavengeFriend? {
        var scavengeFriend = friend
        if (indexPath == nil) {
            if (scavengeFriend.addedToGame) {                                               // remove friend
                if let hIndex = scavengeFriend.headerIndex {
                    selectedFriendsHeaderIndices.append(hIndex)
                    self.removeSelectedFriendImageFromHeader(hIndex)
                    selectedScavengeFriends[hIndex-1] = nil
                    scavengeFriend.addedToGame = false
                }
                selectedFriendsHeaderIndices.append(scavengeFriend.headerIndex!)
                self.removeSelectedFriendImageFromHeader(scavengeFriend.headerIndex!)
                // todo: remove indexPath from selectedIndexPaths
                if let indexOfFirstName = selectedFriendsFirstNames.index(of: scavengeFriend.firstName) {
                    selectedFriendsFirstNames.remove(at: indexOfFirstName)
                    if (selectedFriendsFirstNames.isEmpty) {
                        gameTitle = "Untitled Game"
                    } else {
                        gameTitle = generateGameTitle()
                    }
                    titleTextField.placeholder = gameTitle
                }
            } else {                                                                        // add friend
                selectedFriendsHeaderIndices = selectedFriendsHeaderIndices.sorted().reversed()
                let headerIndex = selectedFriendsHeaderIndices.popLast()
                scavengeFriend.headerIndex = headerIndex
                scavengeFriend.addedToGame = true
                self.addSelectedFriendImageToHeader(scavengeFriend.profileImage, index: headerIndex)
                selectedFriendsFirstNames.append(scavengeFriend.firstName)
                if headerIndex != nil {
                    selectedScavengeFriends[headerIndex! - 1] = scavengeFriend
                }
                gameTitle = generateGameTitle()
                titleTextField.placeholder = gameTitle
            }
            return scavengeFriend
        }
        if scavengeFriend.addedToGame {                                                     // remove friend
            selectedFriendsHeaderIndices.append(scavengeFriend.headerIndex!)
            self.removeSelectedFriendImageFromHeader(scavengeFriend.headerIndex!)
            selectedScavengeFriends[scavengeFriend.headerIndex!-1] = nil
            scavengeFriend.addedToGame = false
            if let indexOfIndexPath = selectedIndexPaths.index(of: indexPath!) {
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
            if scavengeFriend.indexPath != nil {
                selectedIndexPaths.append(scavengeFriend.indexPath!)
            } else {
                selectedIndexPaths.append(indexPath!)
            }
//            selectedIndexPaths.append(scavengeFriend.indexPath!)
            selectedFriendsFirstNames.append(scavengeFriend.firstName)
            if headerIndex != nil {
                selectedScavengeFriends[headerIndex! - 1] = scavengeFriend
            }
            gameTitle = generateGameTitle()
            titleTextField.placeholder = gameTitle
        }
        return scavengeFriend
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelectedRowAt(indexPath: indexPath)
    }
    
    func handleSelectedRowAt(indexPath: IndexPath) {
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
            self.inviteFriend()
        }
        
        if (selectedFriendsFirstNames.count >= 2) {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
            // TODO: - todo: some kind of "message sent" alert
            break
        case MessageComposeResult.cancelled.rawValue:
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
        
        tableView.reloadData()
    }
    
    // MARK: - MagnifiedProfileImageViewDelegate
    func calculateIndexPath(for scavengeFriendID: String) {
    }
    
    func hideOverlayView() {
        overlayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    func xButtonTapped() {
        if let selectedFriend = selectedScavengeFriends[magnifiedPlayerIndex!] {
            if let indexPath = selectedFriend.indexPath {
                print("index path: \(indexPath)")
                if (tableView.indexPathsForVisibleRows?.contains(indexPath))! {
                    handleSelectedRowAt(indexPath: indexPath)
                } else {
                    if let updatedFriend = handleAddRemoveFriend(selectedFriend, indexPath: indexPath) {
                        if ((indexPath as NSIndexPath).section == 0) {
                            recentsDictionary[selectedFriend.id] = updatedFriend
                        } else if ((indexPath as NSIndexPath).section == 1) {
                            scavengeDictionary[selectedFriend.id] = updatedFriend
                        }
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            } else {
                print("no index path")
                if let updatedFriend = handleAddRemoveFriend(selectedFriend, indexPath: nil) {
                    scavengeDictionary[selectedFriend.id] = updatedFriend
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Segue
    @IBAction func startButtonTapped(_ sender: UIBarButtonItem) {
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
        navigationController?.replaceStackWithViewController(destinationViewController: playingGameViewController!)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.isInitialCellConfiguration = true
    }
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MagnifiedProfileImageViewController {
            if let index = magnifiedPlayerIndex, let magnifiedPlayer = selectedScavengeFriends[index] {
                destinationViewController.playerImage = magnifiedPlayer.profileImage
                destinationViewController.playerName = magnifiedPlayer.name
                destinationViewController.delegate = self
                
                destinationViewController.transitioningDelegate = self
                destinationViewController.interactor = interactor
            }
        }
     }
}

extension NewGameViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissNewGameProfileImageAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
