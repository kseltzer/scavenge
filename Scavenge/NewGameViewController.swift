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

var shouldShowKeyboard = false

let inviteBody: String = "Hey! Long time no talk hahaha :) no but seriously I found this really fun app called Scavenge. Kind of a stupid name but it's actually a good game. You should download it so we can play."
let cannotAddAdditionalPlayersMessage = "ya can't have more than \(MAX_PLAYERS) players\nin a game"

class NewGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, MagnifiedProfileImageViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var iconSelectionView: UIView!
    @IBOutlet weak var startButton: UIBarButtonItem!
    
    
    @IBOutlet weak var gameFieldsViewBackgroundImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var profileImagesView: UIView!
    @IBOutlet weak var profileImageViewUser: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend1: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend2: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend3: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend4: ProfileImageView!
    @IBOutlet weak var profileImageViewFriend5: ProfileImageView!
    
    var profileImagesViewHeightContstraintOriginalConstant: CGFloat!
    @IBOutlet weak var profileImagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var overlayView: UIView!
    
    var currentGame: Game? = nil
    
    var recentsDictionary: [String:Player] = [:]
    var recentsIDs: [String] = []
    
    var friendsDictionary: [String:Player] = [:]
    var friendsIDs: [String] = []
    
    var magnifiedPlayerName: String?
    var magnifiedPlayerImage: UIImage?
    var magnifiedPlayerIndex: Int?
    
    var selectedFriends : [Player?] = [nil, nil, nil, nil, nil]
    
    var selectedFriendsHeaderIndices : [Int] = [5, 4, 3, 2, 1]
    var selectedFriendsFirstNames : [String] = []
    
    var filteredRecents : [Player] = []
    var filteredFriends : [Player] = []
    
    var filteredRecentsIDs : [String] = []
    var filteredFriendsIDs : [String] = []
    
    var gameTitle : String = "Game Title"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isInitialCellConfiguration : Bool = true
    
    let interactor = InteractiveTransitionController()
    
    var iconSelectionViewFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        startButton.isEnabled = false
        if let font = FONT_BUTTON {
            startButton.setTitleTextAttributes([NSForegroundColorAttributeName: COLOR_DARK_BROWN_DISABLED], for: .disabled)
            startButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: COLOR_DARK_BROWN], for: .normal)
        }
        
        setupSearchController()
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = NAVIGATION_BAR_TINT_COLOR
        
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
        
        gameFieldsViewBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        gameFieldsViewBackgroundImageView.layer.borderWidth = 8
        
        let path = UIBezierPath(roundedRect:iconSelectionView.bounds,
                                byRoundingCorners:[.topRight, .bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 40.0, height:  5.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        iconSelectionView.layer.mask = maskLayer
        
        iconSelectionViewFrame = iconSelectionView.frame
        
        profileImagesViewHeightContstraintOriginalConstant = profileImagesViewHeightConstraint.constant
        for index in 1...5 {
            setTabBarNegativeStateProfileImage(index: index)
        }
        
        downloadFriendsJSON()
    }

    // MARK: - Communicate With Backend
    func downloadFriendsJSON() {
        recentsDictionary = [:]
        friendsDictionary = [:]
        recentsIDs = []
        friendsIDs = []
        
        do {
            if let filePath = Bundle.main.path(forResource: "friends", ofType: "json"), // TODO: delete this line
                let data = NSData(contentsOfFile: filePath) as? Data, // TODO: replace with actual data
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any],
                let recents = json[JSON_KEY_RECENTS] as? [[String:AnyObject]],
                let friends = json[JSON_KEY_FRIENDS] as? [[String:AnyObject]] {
                
                for player in recents {
                    if let id = player[JSON_KEY_ID] as? String,
                        let firstName = player[JSON_KEY_FIRST_NAME] as? String,
                        let name = player[JSON_KEY_NAME] as? String,
                        let profileImageName = player[JSON_KEY_PROFILE_IMAGE] as? String,
                        let profileImage = UIImage(named: profileImageName) {
                        recentsDictionary[id] = Player(id: id, firstName: firstName, name: name, profileImage: profileImage) // TODO: replace profile image with url
                        recentsIDs.append(id)
                    }
                }
                
                for player in friends {
                    if let id = player[JSON_KEY_ID] as? String,
                        let firstName = player[JSON_KEY_FIRST_NAME] as? String,
                        let name = player[JSON_KEY_NAME] as? String,
                        let profileImageName = player[JSON_KEY_PROFILE_IMAGE] as? String,
                        let profileImage = UIImage(named: profileImageName) {
                        friendsDictionary[id] = Player(id: id, firstName: firstName, name: name, profileImage: profileImage) // TODO: replace profile image with url
                        friendsIDs.append(id)
                    }
                }
                
                tableView.reloadData()
            }
        } catch {
            let alertController = UIAlertController(title: "uh oh!", message: "Error loading data.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            print("json serialization failed")
        }
    }
    
    // TODO: todo: implement to send create game request to backend, send response to destination view controller
    func createGame() {
        
        // the following code parses the json response from creating a game
        do {
            if let filePath = Bundle.main.path(forResource: "game", ofType: "json"), // TODO: delete this line
                let data = NSData(contentsOfFile: filePath) as? Data, // TODO: replace with actual data (containing the response from creating a game)
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any],
                let id = json[JSON_KEY_ID] as? String,
                let title = json[JSON_KEY_TITLE] as? String,
                let topics = json[JSON_KEY_TOPICS] as? [String] {
                    self.currentGame = Game(id: id, title: title, topics: topics)
                }
        } catch {
            let alertController = UIAlertController(title: "uh oh!", message: "Error loading data.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            print("json serialization failed")
        }
    }
    
    // MARK: - UISearchBarDelegate
    func hideProfileImagesView() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            self.profileImagesViewHeightConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: {Void in
            self.searchController.searchBar.becomeFirstResponder()
            shouldShowKeyboard = true
            _ = self.searchBarShouldBeginEditing(self.searchController.searchBar)
        })
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if !shouldShowKeyboard {
            hideProfileImagesView()
        }
        return shouldShowKeyboard
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        shouldShowKeyboard = false
        return true
    }
    
    // MARK: - UISearchControllerDelegate
    func didDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.15, delay: 0.2, options: .curveLinear, animations: {
            self.profileImagesViewHeightConstraint.constant = self.profileImagesViewHeightContstraintOriginalConstant
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        searchController.searchBar.barTintColor = CELL_BORDER_COLOR_DEFAULT
        searchController.searchBar.backgroundImage = UIImage()

        // customize searchBar textField
        searchController.searchBar.searchBarStyle = .prominent
        if let searchBarTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.leftViewMode = UITextFieldViewMode.never
            searchBarTextField.textColor = COLOR_DARK_BROWN
            searchBarTextField.font = FONT_BUTTON
            
            // todo todo todo
            let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor(red:0.30, green:0.18, blue:0.12, alpha:0.4), NSFontAttributeName: FONT_BUTTON!]
            let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search", attributes: placeholderAttributes)
            
            searchBarTextField.attributedPlaceholder = attributedPlaceholder
        }
        
        // custom cancel button
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSFontAttributeName: FONT_BUTTON!, NSForegroundColorAttributeName: UIColor(red:0.30, green:0.18, blue:0.12, alpha:1.0)], for: .normal)

    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case TableViewFriendsSection.recents.rawValue:
                if (searchController.isActive && searchController.searchBar.text != "") {
                    return filteredRecentsIDs.count
                }
                return recentsIDs.count
            case TableViewFriendsSection.friends.rawValue:
                if (searchController.isActive && searchController.searchBar.text != "") {
                    return filteredFriendsIDs.count
                }
                return friendsIDs.count
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
            return friendsDictionary.isEmpty ? nil : kSectionTitleFriendsOnScavenge
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
        returnedView.backgroundColor = UIColor.clear
        
        let sectionTitleLabel = UILabel(frame: CGRect(x: 8, y: topPadding, width: tableView.frame.width, height: 22))
        sectionTitleLabel.text = sectionTitle
        sectionTitleLabel.font = TABLE_VIEW_SECTION_FONT
        returnedView.addSubview(sectionTitleLabel)

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
        var friend : Player!
        switch (section) {
        case .recents:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifier, for: indexPath) as! FriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredRecentsIDs[(indexPath as NSIndexPath).row]
                friend = recentsDictionary[id]!
            } else {
                friend = recentsDictionary[recentsIDs[(indexPath.row)]]!
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
                friend = friendsDictionary[id]!
            } else {
                friend = friendsDictionary[friendsIDs[indexPath.row]]!
            }
            friend.addedToGame = false
            if (!(searchController.isActive && searchController.searchBar.text != nil)) {
                friend.indexPath = indexPath
            }
            friendsDictionary[friend.id] = friend
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
        var friend : Player!
        switch (section) {
        case .recents:
            cell = tableView.dequeueReusableCell(withIdentifier: kFriendCellIdentifier, for: indexPath) as! FriendCell
            if searchController.isActive && searchController.searchBar.text != "" {
                let id = filteredRecentsIDs[(indexPath as NSIndexPath).row]
                friend = recentsDictionary[id]!
            } else {
                friend = recentsDictionary[recentsIDs[indexPath.row]]
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
                friend = friendsDictionary[id]!
            } else {
                friend = friendsDictionary[friendsIDs[indexPath.row]]!
            }
            if (friend.addedToGame) {
                cell.setSelectedAppearance()
            } else {
                cell.setDeselectedAppearance()
            }
            if (!(searchController.isActive && searchController.searchBar.text != nil)) {
                friend.indexPath = indexPath
                friendsDictionary[friend.id] = friend
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
    
    func handleAddRemoveFriend(_ friend : Player) -> Player? {
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
            let friend = friendsDictionary[cell.userID]!
            if let updatedFriend = handleAddRemoveFriend(friend) {
                friendsDictionary[friend.id] = updatedFriend
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
            setTabBarNegativeStateProfileImage(index: headerProfilePhotoIndex)
        }
    }
    
    func setTabBarNegativeStateProfileImage(index: Int) {
        switch (index) {
        case 1:
            if let negativeStateImage = UIImage(named: kNegativeStateProfileImageAliya) {
                profileImageViewFriend1.image = negativeStateImage.compress()
            }
            break
        case 2:
            if let negativeStateImage = UIImage(named: kNegativeStateProfileImageIan) {
                profileImageViewFriend2.image = negativeStateImage.compress()
            }
            break
        case 3:
            if let negativeStateImage = UIImage(named: kNegativeStateProfileImageSachin) {
                profileImageViewFriend3.image = negativeStateImage.compress()
            }
            break
        case 4:
            if let negativeStateImage = UIImage(named: kNegativeStateProfileImageKim) {
                profileImageViewFriend4.image = negativeStateImage.compress()
            }
            break
        case 5:
            if let negativeStateImage = UIImage(named: kNegativeStateProfileImageAC) {
                profileImageViewFriend5.image = negativeStateImage.compress()
            }
            break
        default:
            break
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
            iconButton.imageView?.image = newIcon
        }
        animateHideIconSelectionView()
    }
    
    func animateShowIconSelectionView() {
        iconSelectionView.isHidden = false
        searchController.isActive = false
        
        self.iconSelectionView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.iconSelectionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        if let frame = iconSelectionViewFrame {
            iconSelectionView.frame = frame
        }

        UIView.animate(withDuration: 0.17, delay: 0.0, options: .curveEaseIn, animations: {
            self.iconSelectionView.transform = CGAffineTransform.identity
            self.iconSelectionView.alpha = 1.0
            self.overlayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        }, completion: { (finished) in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.animateHideIconSelectionView))
            self.overlayView.addGestureRecognizer(tapGesture)
            self.overlayView.isUserInteractionEnabled = true
        })
    }
    
    func animateHideIconSelectionView() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            self.iconSelectionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.hideOverlayView()
        }) { (finished) in
            self.iconSelectionView.alpha = 0.0
            self.iconSelectionView.isHidden = true
            self.overlayView.isUserInteractionEnabled = false
        }
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
        textField.placeholder = "Game Title"
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
        filteredFriends = friendsDictionary.values.filter { friend in
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
                            friendsDictionary[selectedFriend.id] = updatedFriend
                        }
                    }
                }
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                if let updatedFriend = handleAddRemoveFriend(selectedFriend) {
                    friendsDictionary[selectedFriend.id] = updatedFriend
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Segue
    @IBAction func startButtonTapped(_ sender: UIBarButtonItem) {
        let queue = DispatchQueue(label: "createGameQueue")
        queue.async(qos: .userInitiated) {
            let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
            let playingGameViewController = playingGameStoryboard.instantiateInitialViewController() as? PlayingGameViewController
            self.createGame()
            
            DispatchQueue.main.async {
                if let currentGame = self.currentGame {
                    playingGameViewController?.currentGame = currentGame
                }
                self.navigationController?.replaceStackWithViewController(destinationViewController: playingGameViewController!)
            }
        }
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
    
    // MARK: - Detailed Player View Animation
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissNewGameProfileImageAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
