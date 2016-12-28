//
//  NewGameViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/21/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import MessageUI

enum TableViewFriendsSection : Int {
    case recents = 0
    case friends = 1
    case inviteFriends = 2
}

let dummyRecents : [Friend] = [
    Friend(name: "Kim Seltzer", id: "1", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Kim", addedToGame: false, headerIndex: nil, indexPath: nil),
    Friend(name: "Aliya Kamalova", id: "2", profileImage: UIImage(named: "aliya")!, firstName: "Aliya", addedToGame: false, headerIndex: nil, indexPath: nil),
    Friend(name: "Charlie Bucket", id: "3", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlie", addedToGame: false, headerIndex: nil, indexPath: nil)
]

let dummyRecentsIDs = ["1", "2", "3"]
let dummyFriendIDs = ["4","5","6","7","8"]

let dummyFriends : [Friend] = [
    Friend(name: "Charlotte York", id: "4", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlotte", addedToGame: false, headerIndex: nil, indexPath: nil),
    Friend(name: "Olivia Rothschild", id: "5", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Olivia", addedToGame: false, headerIndex: nil, indexPath: nil),
    Friend(name: "Paul Goetz", id: "6", profileImage: UIImage(named: "paul")!, firstName: "Paul", addedToGame: false, headerIndex: nil, indexPath: nil),
    Friend(name: "David Seltzer", id: "7", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "David", addedToGame: false, headerIndex: nil, indexPath: nil),
    Friend(name: "Sachin Medhekar", id: "8", profileImage: UIImage(named: "sachin")!, firstName: "Sachin", addedToGame: false, headerIndex: nil, indexPath: nil)
]

let recentsDictionaryFromAPI : [String:Friend] = [
    "1":Friend(name: "Kim Seltzer", id: "1", profileImage: UIImage(named: "fbProfilePic")!, firstName: "Kim", addedToGame: false, headerIndex: nil, indexPath: nil),
    "2":Friend(name: "Aliya Kamalova", id: "2", profileImage: UIImage(named: "aliya")!, firstName: "Aliya", addedToGame: false, headerIndex: nil, indexPath: nil),
    "3":Friend(name: "Charlie Bucket", id: "3", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlie", addedToGame: false, headerIndex: nil, indexPath: nil)
]

var recentsDictionary = recentsDictionaryFromAPI

let scavengeDictionaryFromAPI : [String:Friend] = [
    "4":Friend(name: "Charlotte York", id: "4", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Charlotte", addedToGame: false, headerIndex: nil, indexPath: nil),
    "5":Friend(name: "Olivia Rothschild", id: "5", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "Olivia", addedToGame: false, headerIndex: nil, indexPath: nil),
    "6": Friend(name: "Paul Goetz", id: "6", profileImage: UIImage(named: "paul")!, firstName: "Paul", addedToGame: false, headerIndex: nil, indexPath: nil),
    "7": Friend(name: "David Seltzer", id: "7", profileImage: UIImage(named: "profilePicNegativeState")!, firstName: "David", addedToGame: false, headerIndex: nil, indexPath: nil),
    "8": Friend(name: "Sachin Medhekar", id: "8", profileImage: UIImage(named: "sachin")!, firstName: "Sachin", addedToGame: false, headerIndex: nil, indexPath: nil)
]

var scavengeDictionary = scavengeDictionaryFromAPI

let inviteBody: String = "Hey! Long time no talk hahaha :) no but seriously I found this really fun app called Scavenge. Kind of a stupid name but it's actually a good game. You should download it so we can play."
let cannotAddAdditionalPlayersMessage = "ya can't have more than \(MAX_PLAYERS) players\nin a game"

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, MagnifiedProfileImageViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var iconSelectionView: UIView!
    @IBOutlet weak var startButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var profileImagesView: UIView!
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
    
    var selectedFriends : [Friend?] = [nil, nil, nil, nil, nil]
    
    var selectedFriendsHeaderIndices : [Int] = [5, 4, 3, 2, 1]
    var selectedFriendsFirstNames : [String] = []
    
    var filteredRecents : [Friend] = []
    var filteredFriends : [Friend] = []
    
    var filteredRecentsIDs : [String] = []
    var filteredFriendsIDs : [String] = []
    
    var gameTitle : String = "Game Title"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isInitialCellConfiguration : Bool = true
    
    let interactor = InteractiveTransitionController()

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
        
        
        let path = UIBezierPath(roundedRect:iconSelectionView.bounds,
                                byRoundingCorners:[.topRight, .bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 40.0, height:  5.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        iconSelectionView.layer.mask = maskLayer
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchBarView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        searchController.loadViewIfNeeded()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .words
        searchController.delegate = self
    }
    
    func hideProfileImagesView() {
        self.profileImagesViewHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {Void in
//            self.searchController.isActive = true
        })
    }
    
//    func didPresentSearchController(_ searchController: UISearchController) {
////        searchController.searchBar.becomeFirstResponder()
//    }
//    
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        hideProfileImagesView()
//        return true
//    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case TableViewFriendsSection.recents.rawValue:
                if (searchController.isActive && searchController.searchBar.text != "") {
                    return filteredRecentsIDs.count
                }
                return dummyRecentsIDs.count
            case TableViewFriendsSection.friends.rawValue:
                if (searchController.isActive && searchController.searchBar.text != "") {
                    return filteredFriendsIDs.count
                }
                return dummyFriendIDs.count
            case TableViewFriendsSection.inviteFriends.rawValue:
                return 1
            default:
                break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            if (searchController.isActive && searchController.searchBar.text != "") {
                return filteredRecentsIDs.isEmpty ? nil : kSectionTitleRecents
            }
            return recentsDictionary.isEmpty ? nil : kSectionTitleRecents
        case 1:
            if (searchController.isActive && searchController.searchBar.text != "") {
                return filteredFriendsIDs.isEmpty ? nil : kSectionTitleFriendsOnScavenge
            }
            return scavengeDictionary.isEmpty ? nil : kSectionTitleFriendsOnScavenge
        case 2:
            return kSectionTitleFriendsNotOnScavenge
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle : String? = nil
        var topPadding : CGFloat!
        switch (section) {
        case TableViewFriendsSection.recents.rawValue:
            sectionTitle = kSectionTitleRecents
            topPadding = 3
            break
        case TableViewFriendsSection.friends.rawValue:
            sectionTitle = kSectionTitleFriendsOnScavenge
            topPadding = 0
            break
        case TableViewFriendsSection.inviteFriends.rawValue:
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
            return tableView.dequeueReusableCell(withIdentifier: "inviteFriendsCell") as! InviteFriendsCell
        }
        if (isInitialCellConfiguration) {
            return self.configureCellInitially(indexPath, section: TableViewFriendsSection(rawValue: indexPath.section)!)
        } else {
            return self.configureCell(indexPath, section: TableViewFriendsSection(rawValue: indexPath.section)!)
        }
    }
    
    func configureCellInitially(_ indexPath: IndexPath, section: TableViewFriendsSection) -> FriendCell {
        var cell : FriendCell = FriendCell()
        var friend : Friend!
        switch (section) {
        case .recents:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifier, for: indexPath) as! FriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredRecentsIDs[(indexPath as NSIndexPath).row]
                friend = recentsDictionary[id]!
            } else {
                friend = recentsDictionary[dummyRecentsIDs[(indexPath as NSIndexPath).row]]!
            }
            friend.addedToGame = false
            if (!(searchController.isActive && searchController.searchBar.text != nil)) {
                friend.indexPath = indexPath
            }
            recentsDictionary[friend.id] = friend
            break
        case .friends:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifier, for: indexPath) as! FriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredFriendsIDs[(indexPath as NSIndexPath).row]
                friend = scavengeDictionary[id]!
            } else {
                friend = scavengeDictionary[dummyFriendIDs[(indexPath as NSIndexPath).row]]!
            }
            friend.addedToGame = false
            if (!(searchController.isActive && searchController.searchBar.text != nil)) {
                friend.indexPath = indexPath
            }
            scavengeDictionary[friend.id] = friend
            break
        default:
            return cell
        }
        cell.userID = friend.id
        cell.nameLabel.text = friend.name
        cell.profileImage.layoutIfNeeded()
        cell.profileImage.circular()
        cell.profileImage.image = friend.profileImage
        cell.setDeselectedAppearance()
        return cell
    }
    
    func configureCell(_ indexPath: IndexPath, section: TableViewFriendsSection) -> FriendCell {
        var cell : FriendCell = FriendCell()
        var friend : Friend!
        switch (section) {
        case .recents:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifier, for: indexPath) as! FriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredRecentsIDs[(indexPath as NSIndexPath).row]
                friend = recentsDictionary[id]!
            } else {
                friend = recentsDictionary[dummyRecentsIDs[(indexPath as NSIndexPath).row]]!
            }
            if (friend.addedToGame) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            if (!(searchController.isActive && searchController.searchBar.text != nil)) {
                friend.indexPath = indexPath
                recentsDictionary[friend.id] = friend
            }
            break
        case .friends:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifier, for: indexPath) as! FriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredFriendsIDs[(indexPath as NSIndexPath).row]
                friend = scavengeDictionary[id]!
            } else {
                friend = scavengeDictionary[dummyFriendIDs[(indexPath as NSIndexPath).row]]!
            }
            if (friend.addedToGame) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            if (!(searchController.isActive && searchController.searchBar.text != nil)) {
                friend.indexPath = indexPath
                scavengeDictionary[friend.id] = friend
            }
            break
        default:
            return cell
        }
        cell.userID = friend.id
        cell.nameLabel.text = friend.name
        cell.profileImage.layoutIfNeeded()
        cell.profileImage.circular()
        cell.profileImage.image = friend.profileImage
        return cell
    }
    
    @IBAction func tappedProfileImage(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            showMagnifiedProfileImage(index: tag-1)
        }
    }
    
    func showMagnifiedProfileImage(index: Int) {
        if (selectedFriends[index] != nil && !searchController.isActive) {
            magnifiedPlayerIndex = index
            overlayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            self.performSegue(withIdentifier: "showMagnifiedProfileImageView", sender: self)
        }
    }
    
    func handleAddRemoveFriend(_ friend : Friend) -> Friend? {
        var friend = friend
        if friend.addedToGame {                                                             // remove friend
            selectedFriendsHeaderIndices.append(friend.headerIndex!)
            self.removeSelectedFriendImageFromHeader(friend.headerIndex!)
            selectedFriends[friend.headerIndex!-1] = nil
            friend.addedToGame = false
            if let indexOfFirstName = selectedFriendsFirstNames.index(of: friend.firstName) {
                selectedFriendsFirstNames.remove(at: indexOfFirstName)
                if (selectedFriendsFirstNames.isEmpty) {
                    gameTitle = "Game Title"
                } else {
                    gameTitle = generateGameTitle()
                }
                titleTextField.placeholder = gameTitle
            }
        } else if (selectedFriendsHeaderIndices.count == 0) {                                       // maximum friends added alert
            let alertController = UIAlertController(title: kErrorTitle, message: cannotAddAdditionalPlayersMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAcceptFaultErrorMessage, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return nil
        } else {                                                                                    // add friend
            selectedFriendsHeaderIndices = selectedFriendsHeaderIndices.sorted().reversed()
            let headerIndex = selectedFriendsHeaderIndices.popLast()
            friend.headerIndex = headerIndex
            friend.addedToGame = true
            self.addSelectedFriendImageToHeader(friend.profileImage, index: headerIndex)
            selectedFriendsFirstNames.append(friend.firstName)
            if headerIndex != nil {
                selectedFriends[headerIndex! - 1] = friend
            }
            gameTitle = generateGameTitle()
            titleTextField.placeholder = gameTitle
        }
        return friend
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelectedRowAt(indexPath: indexPath)
    }
    
    func handleSelectedRowAt(indexPath: IndexPath) {
        if (titleTextField.isFirstResponder) {
            titleTextField.resignFirstResponder()
        }
        
        isInitialCellConfiguration = false
        
        switch indexPath.section {
        case TableViewFriendsSection.recents.rawValue:
            let cell = tableView.cellForRow(at: indexPath) as! FriendCell
            let friend = recentsDictionary[cell.userID]!
            if let updatedFriend = handleAddRemoveFriend(friend) {
                recentsDictionary[friend.id] = updatedFriend
            }
            break
        case TableViewFriendsSection.friends.rawValue:
            let cell = tableView.cellForRow(at: indexPath) as! FriendCell
            let friend = scavengeDictionary[cell.userID]!
            if let updatedFriend = handleAddRemoveFriend(friend) {
                scavengeDictionary[friend.id] = updatedFriend
            }
            break
        case TableViewFriendsSection.inviteFriends.rawValue:
            self.inviteFriends()
            break
        default:
            break
        }
        
        if (selectedFriendsFirstNames.count >= 2) {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
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

    // MARK: - Icon Selection
    @IBAction func iconButtonTapped(_ sender: Any) {
        if (iconSelectionView.isHidden) {
            animateShowIconSelectionView()
        } else {
            animateHideIconSelectionView()
        }
    }
    
    @IBAction func selectedNewGameIcon(_ sender: UIButton) {
        if let newIcon = sender.currentImage {
            iconButton.setImage(newIcon, for: .normal)
        }
        animateHideIconSelectionView()
    }
    
    func animateShowIconSelectionView() {
        iconSelectionView.isHidden = false
        searchController.isActive = false
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
            self.iconSelectionView.alpha = 1.0
            self.overlayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        }, completion: { (finished) in
            self.overlayView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.animateHideIconSelectionView))
            self.overlayView.addGestureRecognizer(tapGesture)
        })
    }
    
    func animateHideIconSelectionView() {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
            self.iconSelectionView.alpha = 0.0
            self.hideOverlayView()
        }, completion: { (finished) in
            self.iconSelectionView.isHidden = true
            self.overlayView.isUserInteractionEnabled = false
        })
    }
    
    
    
    // MARK: - UITextFieldDelegate
    func generateGameTitle() -> String {
        return "Scavenge with \(selectedFriendsFirstNames.joined(separator: ", "))"
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
        tableView.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        titleTextField.resignFirstResponder()
    }
    
    // MARK: - Invite Friends
    
    func inviteFriends() {
        let inviteMessage = [inviteBody]
        let activityViewController = UIActivityViewController(activityItems: inviteMessage, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks, .postToVimeo, .saveToCameraRoll, .print]
        self.present(activityViewController, animated: true, completion: nil)
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
    
        filteredFriendsIDs = []
        filteredFriends = scavengeDictionary.values.filter { friend in
            return friend.name.lowercased().contains(searchText.lowercased())
        }
        for friend in filteredFriends {
            filteredFriendsIDs.append(friend.id)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - MagnifiedProfileImageViewDelegate
    func calculateIndexPath(for friendID: String) {
    }
    
    func hideOverlayView() {
        overlayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    func xButtonTapped() {
        if let selectedFriend = selectedFriends[magnifiedPlayerIndex!] {
            if let indexPath = selectedFriend.indexPath {
                if (tableView.indexPathsForVisibleRows?.contains(indexPath))! {
                    handleSelectedRowAt(indexPath: indexPath)
                } else {
                    if let updatedFriend = handleAddRemoveFriend(selectedFriend) {
                        if ((indexPath as NSIndexPath).section == 0) {
                            recentsDictionary[selectedFriend.id] = updatedFriend
                        } else if ((indexPath as NSIndexPath).section == 1) {
                            scavengeDictionary[selectedFriend.id] = updatedFriend
                        }
                    }
                }
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                if let updatedFriend = handleAddRemoveFriend(selectedFriend) {
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
            if let index = magnifiedPlayerIndex, let magnifiedPlayer = selectedFriends[index] {
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
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissNewGameProfileImageAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
