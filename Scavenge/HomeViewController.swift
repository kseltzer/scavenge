
//
//  HomeViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import SwiftyJSON
import AWSS3

enum TableViewSection : Int {
    case invites = 0
    case results = 1
    case activeGames = 2
    case yourMove = 3
    case theirMove = 4
    case completedGames = 5
}

enum SectionType {
    case main
    case subsection
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, InvitationCellProtocol {
    
    let interactor = InteractiveTransitionController()
    
    @IBOutlet weak var tableView: UITableView!

    var activeInvitationCell : InvitationCell? = nil
    var declinedInvitationData: (invitation: Game, row: Int)? = nil
    
    var gamesInvites: [Game] = []
    var gamesResults: [Game] = []
    var gamesYourMove: [Game] = []
    var gamesTheirMove: [Game] = []
    var gamesCompleted: [Game] = []
    
    @IBAction func createNewGameButtonTapped(_ sender: UIBarButtonItem) {
        let createGameStoryboard = UIStoryboard(name: kCreateGameStoryboard, bundle: nil)
        let createGameViewController = createGameStoryboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(createGameViewController!, animated: true);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 85
        
        
        navigationItem.backBarButtonItem = customBackBarItem()
        adjustLeftBarButtonHorizontalSpacing()
        adjustRightBarButtonHorizontalSpacing()
        
        // set nav bar to transparent
        if let navigationController = navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
        }
        
        // Configure refresh control
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.addTarget(self, action: #selector(self.refreshGames), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl!.tintColor = COLOR_DARK_BROWN
        self.tableView?.addSubview(self.tableView.refreshControl!)
        
        // download json
        loadGames()
    }
    
    func downloadImageFromBucketTest() {
        let key = "C01F7131-DE5B-434F-A2F8-0270129C3B86-29054-0000AC5BD44D2677.jpg"
        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(key)")
       
        if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
        
            downloadRequest.bucket = AWS_BUCKET
            downloadRequest.key = "C01F7131-DE5B-434F-A2F8-0270129C3B86-29054-0000AC5BD44D2677.jpg"
            downloadRequest.downloadingFileURL = downloadingFileURL
            
            let transferManager = AWSS3TransferManager.default()
            transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                
                if let error = task.error as? NSError {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error downloading: \(downloadRequest.key) Error: \(error)")
                        }
                    } else {
                        print("Error downloading: \(downloadRequest.key) Error: \(error)")
                    }
                    return nil
                }
                print("Download complete for: \(downloadRequest.key)")
                let downloadOutput = task.result
                print("Download output: ", downloadOutput as Any)
                

                return nil
            })
        }
    }
    
    func uploadImageToBucketTest() {
        let transferManager = AWSS3TransferManager.default()
        
        let ext = "jpg"
        let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("sachin.jpg")!
        
        // save image to URL
        do {
            try UIImageJPEGRepresentation(UIImage(named: "sachin")!, 1)?.write(to: imageURL)
        } catch { print("couldn't save") }
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = AWS_BUCKET
        uploadRequest?.key = ProcessInfo.processInfo.globallyUniqueString + "." + ext
        uploadRequest?.body = imageURL
        uploadRequest?.contentType = "image/" + ext
        
        if let request = uploadRequest {
            transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                // Do something with the response
                if let error = task.error {
                    print("Upload failed ❌ (\(error))")
                }
                if task.result != nil {
//                    let s3URL = NSURL(string: "http://s3.amazonaws.com/\(AWS_BUCKET)/\(uploadRequest?.key!)")
                    let s3URL2 = URL(string: "http://s3.amazonaws.com/\(AWS_BUCKET)/6E321038-6683-4420-8131-B2E632BD8B45-28869-0000AC44E81B9A57.jpg")
                    print("Uploaded to:\n\(s3URL2)")
                }
                else {
                    print("Unexpected empty result.")
                }
                return nil
            })
            
        }
    }
    
    // MARK: - Custom Bar Button Items
    func segueToNewGameViewController() {
        performSegue(withIdentifier: "createGameSegue", sender: self)
    }
    
    func adjustLeftBarButtonHorizontalSpacing() {
        let screenSize: CGRect = UIScreen.main.bounds
        switch (screenSize.width) {
        case iPHONE_6, iPHONE_6S, iPHONE_7, iPHONE_7S:
            if let menuButton = navigationItem.leftBarButtonItem {
                let negativeSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                negativeSpaceButton.width = -8
                navigationItem.setLeftBarButtonItems([negativeSpaceButton, menuButton], animated: false)
            }
            break
        case iPHONE_SE, iPHONE_5, iPHONE_5S:
            break
        case iPHONE_6_PLUS, iPHONE_7_PLUS:
            if let menuButton = navigationItem.leftBarButtonItem {
                let negativeSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                negativeSpaceButton.width = -10
                navigationItem.setLeftBarButtonItems([negativeSpaceButton, menuButton], animated: false)
            }
            break
        default:
            break
        }
    }
    
    func adjustRightBarButtonHorizontalSpacing() {let plusButton = UIButton(type: .custom)
        plusButton.setImage(UIImage(named: "plus"), for: .normal)
        plusButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        plusButton.addTarget(self, action: #selector(segueToNewGameViewController), for: .touchUpInside)
        
        let rightBarButtonItem = SBarButtonItem(customView: plusButton)

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceButton.width = -6
        navigationItem.setRightBarButtonItems([spaceButton, rightBarButtonItem], animated: false)
    }
    
    // MARK: - Manage JSON
    func refreshGames() {
        gamesInvites = []
        gamesResults = []
        gamesYourMove = []
        gamesTheirMove = []
        gamesCompleted = []
        
        loadGames()
    }
    
    func loadGames() {
        let request = GetGamesRequest(facebook_id: currentUserID, facebook_token: currentUserAccessToken)
        request.completionBlock = { (response: JSON?, error: Any?) -> Void in
            if let json = response {
                print("json: ", json)
                self.parseJson(json: json)
            }
            
            self.tableView.refreshControl?.endRefreshing()
        }
        request.execute()
    }
    
    func parseJson(json: JSON) {
        let icon = 0 // TODO: DELETE THIS DUMMY DATA, constant unnecessary
        
        let yourPlay = json["yourPlay"]
        for gameObject in yourPlay {
            let game = gameObject.1
            if  let id = game[JSON_KEY_ID].string,
                let title = game["title"].string,
                let creator = game["creator"].int//,
                //                let dateCreated = game["dateCreated"].string,
//                let icon = game["icon"].int 
                { // TODO: parse icon, should be returned as int 0-9 each num representing an icon image
                
                let creatorName = "Kim" // TODO: replace dummy data
                let creatorID = String(creator)
                let status = GameStatus.yourMove
                let subtitle = GameSubtitle.yourPlay
                gamesYourMove.append(Game(id: id, title: title, icon: icon, creator: Player(id: creatorID, name: creatorName), status: status, subtitle: subtitle))
            }
        }
        
        let yourVote = json["yourVote"]
        for gameObject in yourVote {
            let game = gameObject.1
            if  let id = game[JSON_KEY_ID].string,
                let title = game["title"].string,
                let creator = game["creator"].int//,
                //                let dateCreated = game["dateCreated"].string,
//                let icon = game["icon"].int 
                { // TODO: parse icon, should be returned as int 0-9 each num representing an icon image
                
                let creatorName = "Kim" // TODO: replace dummy data
                let creatorID = String(creator)
                let subtitle = GameSubtitle.yourVote
                let status = GameStatus.yourMove
                gamesYourMove.append(Game(id: id, title: title, icon: icon, creator: Player(id: creatorID, name: creatorName), status: status, subtitle: subtitle))
            }
        }
        
        let theirPlay = json["theirPlay"]
        for gameObject in theirPlay {
            let game = gameObject.1
            if let id = game[JSON_KEY_ID].string,
                let title = game["title"].string,
//                let icon = game["icon"].int // TODO: parse icon, should be returned as int 0-9 each num representing an icon image
                let creator = game["creator"].int //,
//                let creatorName = game["creatorName"].string
                {
                    
                let creatorID = String(creator)
                let subtitle = GameSubtitle.theirPlay
                let status = GameStatus.theirMove
                let creatorName = "Kim" // TODO: replace dummy data
                
                var players: [Player] = []
                let playersArray = game["players"].arrayValue
                for player in playersArray {
                    let player = player.dictionaryValue
                    if let name = player["name"]?.string, let picture_url = player["profilePicture"]?.string, let id = player["id"]?.number {
                        players.append(Player(id: "\(id)", firstName: name, name: name, picture_url: picture_url))
                    }
                }
                    
                gamesTheirMove.append(Game(id: id, title: title, icon: icon, creator: Player(id: creatorID, name: creatorName), status: status, subtitle: subtitle, players: players))
            }
        }
        
        let theirVote = json["theirVote"]
        for gameObject in theirVote {
            let game = gameObject.1
            if let id = game[JSON_KEY_ID].string,
                let title = game["title"].string,
//                let icon = game["icon"].int, // TODO: parse icon, should be returned as int 0-9 each num representing an icon image
                let creator = game["creator"].int //,
                //                let creatorName = game["creatorName"].string
            {
                
                let creatorID = String(creator)
                let subtitle = GameSubtitle.theirVote
                let status = GameStatus.theirMove
                let creatorName = "Kim" // TODO: replace dummy data
                gamesTheirMove.append(Game(id: id, title: title, icon: icon, creator: Player(id: creatorID, name: creatorName), status: status, subtitle: subtitle))
            }
        }
        
        let completed = json["closed"]
        for gameObject in completed {
            let game = gameObject.1
            if  let id = game[JSON_KEY_ID].string,
                let title = game["title"].string,
                let creator = game["creator"].int//,
                //                let dateCreated = game["dateCreated"].string,
//                let icon = game["icon"].int 
                { // TODO: parse icon, should be returned as int 0-9 each num representing an icon image
                
                let creatorName = "Kim" // TODO: replace dummy data
                let creatorID = String(creator)
                let subtitle = GameSubtitle.completed
                let status = GameStatus.completed
                gamesCompleted.append(Game(id: id, title: title, icon: icon, creator: Player(id: creatorID, name: creatorName), status: status, subtitle: subtitle))
            }
        }
    
        // animate table refresh
        DispatchQueue.main.async(execute: {
            UIView.transition(with: self.tableView, duration: 0.1, options: .curveEaseInOut, animations: {
                self.tableView.reloadData()
            }, completion: nil)
        })
        
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case TableViewSection.invites.rawValue:
            return gamesInvites.count
        case TableViewSection.results.rawValue:
            return gamesResults.count
        case TableViewSection.activeGames.rawValue:
            return 0
        case TableViewSection.yourMove.rawValue:
            return gamesYourMove.count
        case TableViewSection.theirMove.rawValue:
            return gamesTheirMove.count
        case TableViewSection.completedGames.rawValue:
            return gamesCompleted.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameCell!
        var game: Game
        switch ((indexPath as NSIndexPath).section) {
        case TableViewSection.invites.rawValue:
            game = gamesInvites[indexPath.row]
            let inviteCell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath) as! InvitationCell
            inviteCell.gameTitleLabel.text = game.title
            inviteCell.gameImageView.image = getImageFrom(icon: game.icon)
            if let creator = game.creator {
                inviteCell.invitedByLabel.text = "invited by: \(creator.name)"
            }
            inviteCell.delegate = self
            return inviteCell
        case TableViewSection.results.rawValue:
            game = gamesResults[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        case TableViewSection.activeGames.rawValue:
            return UITableViewCell()
        case TableViewSection.yourMove.rawValue:
            game = gamesYourMove[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        case TableViewSection.theirMove.rawValue:
            game = gamesTheirMove[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        case TableViewSection.completedGames.rawValue:
            game = gamesCompleted[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        default:
            return UITableViewCell()
        }
        cell.gameTitleLabel.text = game.title
        cell.subtitleLabel.text = game.subtitle
        cell.gameImageView?.image = getImageFrom(icon: game.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case TableViewSection.invites.rawValue:
            if (gamesInvites.isEmpty) {
                return nil
            }
            return kSectionTitleInvites
        case TableViewSection.results.rawValue:
            if (gamesResults.isEmpty) {
                return nil
            }
            return kSectionTitleResults
        case TableViewSection.activeGames.rawValue:
            return kSectionTitleActiveGames
        case TableViewSection.yourMove.rawValue:
            return kSubsectionTitleYourMove
        case TableViewSection.theirMove.rawValue:
            return kSubsectionTitleTheirMove
        case TableViewSection.completedGames.rawValue:
            return kSectionTitleCompletedGames
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle : String!
        var sectionType : SectionType!
        switch (section) {
        case TableViewSection.invites.rawValue:
            sectionTitle = kSectionTitleInvites
            sectionType = .main
        case TableViewSection.results.rawValue:
            sectionTitle = kSectionTitleResults
            sectionType = .main
        case TableViewSection.activeGames.rawValue:
            sectionTitle = kSectionTitleActiveGames
            sectionType = .main
        case TableViewSection.yourMove.rawValue:
            sectionTitle = kSubsectionTitleYourMove
            sectionType = .subsection
        case TableViewSection.theirMove.rawValue:
            sectionTitle = kSubsectionTitleTheirMove
            sectionType = .subsection
        case TableViewSection.completedGames.rawValue:
            sectionTitle = kSectionTitleCompletedGames
            sectionType = .main
        default:
            sectionTitle = ""
        }
        
        return viewForHeaderInSectionWithTitle(sectionType, title: sectionTitle)
    }
    
    func viewForHeaderInSectionWithTitle(_ sectionType: SectionType, title: String) -> UIView {
        var height : CGFloat!
        var font : UIFont!
        if sectionType == .main {
            height = 26
            font = TABLE_VIEW_SECTION_FONT
        } else if sectionType == .subsection {
            height = 18
            font = TABLE_VIEW_SUBSECTION_FONT
        }
        
        let sectionTitleView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: tableView.frame.width, height: height))
        label.text = title
        label.font = font
        label.textColor = UIColor.white
        sectionTitleView.addSubview(label)
        
        return sectionTitleView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch ((indexPath as NSIndexPath).section) {
        case TableViewSection.invites.rawValue:
            if let invitationCell = tableView.cellForRow(at: indexPath) as? InvitationCell {
                if (invitationCell.isOpen) {
                    invitationCell.resetConstraintConstantsToZero(animated: true)
                    invitationCell.isOpen = false
                    invitationCell.acceptButton.isUserInteractionEnabled = false
                } else {
                    invitationCell.setConstraintsToShowAllButtons(animated: true)
                    invitationCell.isOpen = true
                    invitationCell.acceptButton.isUserInteractionEnabled = true
                }
            }
            break
        case TableViewSection.results.rawValue, TableViewSection.completedGames.rawValue:
            let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
            let resultsViewController = playingGameStoryboard.instantiateViewController(withIdentifier: kGameResultsViewController)
            self.navigationController?.pushViewController(resultsViewController, animated: true);
            break
        case TableViewSection.activeGames.rawValue:
            break
        case TableViewSection.yourMove.rawValue:
            let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
            let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
            self.navigationController?.pushViewController(playingGameViewController!, animated: true);
            break
        case TableViewSection.theirMove.rawValue:
            let mainStoryboard = UIStoryboard(name: kMainStoryboard, bundle: nil)
            let gameSummaryViewController = mainStoryboard.instantiateViewController(withIdentifier: kGameSummaryViewController) as! GameSummaryViewController
            gameSummaryViewController.game = gamesTheirMove[indexPath.row]
            self.navigationController?.pushViewController(gameSummaryViewController, animated: true);
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Slide On Invite Cells
    func handleSwipeOnInviteCell(sender: UIPanGestureRecognizer, cell: InvitationCell) {
        switch sender.state {
        case .began:
            cell.panStartingPoint = sender.translation(in: view)
            cell.startingTrailingHideButtonsViewConstant = cell.hideButtonsViewTrailingConstraint.constant
            activeInvitationCell = cell
            break
        case .changed:
            let activeCell : InvitationCell!
            if (activeInvitationCell != nil) {
                activeCell = activeInvitationCell
            } else {
                activeCell = cell
            }
            let currentPoint = sender.translation(in: view)
            if (activeCell.panStartingPoint == nil) {
                activeCell.panStartingPoint = sender.translation(in: view)
            }
            let deltaX = currentPoint.x - activeCell.panStartingPoint!.x
            let isPanningLeft = (currentPoint.x < activeCell.panStartingPoint!.x) ? true : false
            
            if (!activeCell.isOpen) { // cell was closed and is now opening
                activeCell.isOpen = true
                activeCell.acceptButton.isUserInteractionEnabled = true
                if (isPanningLeft) {
                    let constant = min(-deltaX, activeCell.getTotalButtonWidth()-2)
                    if (constant == activeCell.getTotalButtonWidth()-2) {
                        activeCell.setConstraintsToShowAllButtons(animated: false)
                        activeCell.isOpen = true
                        activeCell.acceptButton.isUserInteractionEnabled = true
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                } else { // panning right
                    let constant = max(-deltaX, 0)
                    if (constant == 0) {
                        activeCell.resetConstraintConstantsToZero(animated: false)
                        activeCell.isOpen = false
                        activeCell.acceptButton.isUserInteractionEnabled = false
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                }
            } else {    // cell was at least partially open
                if (activeCell.startingTrailingHideButtonsViewConstant == nil) {
                    activeCell.startingTrailingHideButtonsViewConstant = activeCell.hideButtonsViewTrailingConstraint.constant
                }
                let adjustment = activeCell.startingTrailingHideButtonsViewConstant! - deltaX
                if (isPanningLeft) {
                    let constant = min(adjustment, activeCell.getTotalButtonWidth()-2)
                    if (constant == activeCell.getTotalButtonWidth()-2) {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                        activeCell.setConstraintsToShowAllButtons(animated: false)
                        activeCell.isOpen = true
                        activeCell.acceptButton.isUserInteractionEnabled = true
                        return
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                } else { // panning right
                    let constant = max(adjustment, 0)
                    if (activeCell.hideButtonsViewTrailingConstraint.constant == 0) {
                        activeCell.resetConstraintConstantsToZero(animated: false)
                        activeCell.isOpen = false
                        activeCell.acceptButton.isUserInteractionEnabled = false
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                }
            }
            activeCell.hideButtonsViewLeadingConstraint.constant = -activeCell.hideButtonsViewTrailingConstraint.constant //+ 16
            break
        case .ended:
            let activeCell : InvitationCell!
            if (activeInvitationCell != nil) {
                activeCell = activeInvitationCell
            } else {
                activeCell = cell
            }
            if (activeCell.startingTrailingHideButtonsViewConstant == 8) { // cell was opening
                let twoThirdsOfRightButton = cell.acceptButton.frame.width * 2/3
                if (activeCell.hideButtonsViewTrailingConstraint.constant >= twoThirdsOfRightButton) { // open all the way
                    activeCell.setConstraintsToShowAllButtons(animated: true)
                    activeCell.isOpen = true
                    activeCell.acceptButton.isUserInteractionEnabled = true
                } else { // re-close
                    activeCell.resetConstraintConstantsToZero(animated: true)
                    activeCell.isOpen = false
                    activeCell.acceptButton.isUserInteractionEnabled = false
                }
            } else { // cell was closing
                let rightButtonPlusHalfOfLeftButton = activeCell.acceptButton.frame.width + activeCell.declineButton.frame.width / 2
                if (activeCell.hideButtonsViewTrailingConstraint.constant >= rightButtonPlusHalfOfLeftButton) { // re-open all the way
                    activeCell.setConstraintsToShowAllButtons(animated: true)
                } else { // close
                    activeCell.resetConstraintConstantsToZero(animated: true)
                    activeCell.isOpen = false
                    activeCell.acceptButton.isUserInteractionEnabled = false
                }
            }
            activeInvitationCell = nil
            break
        case .cancelled:
            let activeCell : InvitationCell!
            if (activeInvitationCell != nil) {
                activeCell = activeInvitationCell
            } else {
                activeCell = cell
            }
            if (activeCell.startingTrailingHideButtonsViewConstant == 8) { // cell was closed: reset everything to 0
                activeCell.resetConstraintConstantsToZero(animated: true)
                activeCell.isOpen = false
                activeCell.acceptButton.isUserInteractionEnabled = false
            } else { // cell was open: reset to the open state
                activeCell.setConstraintsToShowAllButtons(animated: true)
                activeCell.isOpen = true
                activeCell.acceptButton.isUserInteractionEnabled = true
            }
            activeInvitationCell = nil
            break
        default:
            break
        }
    }
    
    func acceptedGameInvite(cell: InvitationCell) {
        removeInvitationFromTableView(for: cell, withAnimation: .left, andColor: cell.acceptButton.backgroundColor)
    }
    
    func declinedGameInvite(cell: InvitationCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            declinedInvitationData = (gamesInvites[indexPath.row], indexPath.row)
        }
        removeInvitationFromTableView(for: cell, withAnimation: .right, andColor: cell.declineButton.backgroundColor)
    }
    
    func removeInvitationFromTableView(for cell: InvitationCell, withAnimation animation: UITableViewRowAnimation, andColor color: UIColor?) {
        if let backgroundColor = color {
            cell.cellBackgroundImageView.layer.borderColor = backgroundColor.cgColor
            cell.roundedBorderView.backgroundColor = backgroundColor
            cell.acceptButton.backgroundColor = backgroundColor
            cell.declineButton.backgroundColor = backgroundColor
        }
        if let indexPath = tableView.indexPath(for: cell) {
            gamesInvites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: animation)
        }
        if let declinedInvitation = declinedInvitationData {
            if let creator = declinedInvitation.invitation.creator {
                let invitedBy = creator.name
                let alertController = UIAlertController(title: nil, message: "You just declined a game invitation from \(invitedBy)", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (undoAction) in
                    let insultAlertController = UIAlertController(title: nil, message: "Oh wow, \(invitedBy) must really suck", preferredStyle: .alert)
                    let agreeAction = UIAlertAction(title: "hah, true", style: .default, handler: nil)
                    insultAlertController.addAction(agreeAction)
                    self.present(insultAlertController, animated: true, completion: { Void in
                        self.declinedInvitationData = nil
                    })
                })
                let undoAction = UIAlertAction(title: "Undo", style: .default, handler: { (undoAction) in
                    self.gamesInvites.insert((self.declinedInvitationData?.invitation)!, at: 0)
                    self.tableView.reloadSections([TableViewSection.invites.rawValue], with: .automatic)
                    self.declinedInvitationData = nil
                })
                alertController.addAction(undoAction)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Slideout Menu
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: kShowMenuSegue, sender: self)
    }
    
    @IBAction func handleEdgeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
            MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
                self.performSegue(withIdentifier: kShowMenuSegue, sender: self)
        }
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        if let activeCell = activeInvitationCell {
            handleSwipeOnInviteCell(sender: sender, cell: activeCell)
            return
        }
        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        if (view.convert(tableView.frame, from: tableView.superview).contains(location)) {
            let locationInTableView = tableView.convert(location, from: view)
            let indexPath = tableView.indexPathForRow(at: locationInTableView)
            if (indexPath?.section == TableViewSection.invites.rawValue) {
                if let cell = tableView.cellForRow(at: indexPath!) as? InvitationCell {
                    if (cell.isOpen || translation.x < 0) { // cell is swiped open or user swiped to the left
                        handleSwipeOnInviteCell(sender: sender, cell: cell)
                        return
                    }
                }
            }
        }
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.performSegue(withIdentifier: kShowMenuSegue, sender: self)
        }
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowMenuAnimator()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.currentScreen = .Home
        }
    }
    
}
