
//
//  HomeViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

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
        tableView.backgroundColor = COLOR_MINT_GREEN
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = COLOR_MINT_GREEN
        navigationController?.navigationBar.isTranslucent = true
        
        downloadJSON()
        

    }
    
    // MARK: - Manage JSON
    func downloadJSON() {
        gamesInvites = []
        gamesResults = []
        gamesYourMove = []
        gamesTheirMove = []
        gamesCompleted = []
        
        do {
            if let filePath = Bundle.main.path(forResource: "games", ofType: "json"), // TODO: delete this line
                let data = NSData(contentsOfFile: filePath) as? Data, // TODO: replace with actual data
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any],
                let invites = json["invites"] as? [[String:AnyObject]],
                let results = json["results"] as? [[String:AnyObject]],
                let yourMove = json["yourMove"] as? [[String:AnyObject]],
                let theirMove = json["theirMove"] as? [[String:AnyObject]],
                let completed = json["completed"] as? [[String:AnyObject]] {
                
                for game in invites {
                    if let id = game[JSON_KEY_ID] as? Int,
                        let title = game["title"] as? String,
                        let icon = game["icon"] as? String, // TODO: change to URL
                        let creatorID = game["creatorID"] as? Int,
                        let creatorName = game["creatorName"] as? String,
                        let status = game["status"] as? String {
                            gamesInvites.append(Game(id: id, title: title, icon: UIImage(named: icon)!, creator: Player(id: creatorID, name: creatorName), status: GameStatus(rawValue: status)!))
                    }
                }
                
                for game in results {
                    if let id = game[JSON_KEY_ID] as? Int,
                        let title = game["title"] as? String,
                        let icon = game["icon"] as? String, // TODO: change to URL
                        let creatorID = game["creatorID"] as? Int,
                        let creatorName = game["creatorName"] as? String,
                        let status = game["status"] as? String {
                        gamesResults.append(Game(id: id, title: title, icon: UIImage(named: icon)!, creator: Player(id: creatorID, name: creatorName), status: GameStatus(rawValue: status)!))
                    }
                }
                
                for game in yourMove {
                    if let id = game[JSON_KEY_ID] as? Int,
                        let title = game["title"] as? String,
                        let icon = game["icon"] as? String, // TODO: change to URL
                        let creatorID = game["creatorID"] as? Int,
                        let creatorName = game["creatorName"] as? String,
                        let status = game["status"] as? String {
                        gamesYourMove.append(Game(id: id, title: title, icon: UIImage(named: icon)!, creator: Player(id: creatorID, name: creatorName), status: GameStatus(rawValue: status)!))
                    }
                }
                
                for game in theirMove {
                    if let id = game[JSON_KEY_ID] as? Int,
                        let title = game["title"] as? String,
                        let icon = game["icon"] as? String, // TODO: change to URL
                        let creatorID = game["creatorID"] as? Int,
                        let creatorName = game["creatorName"] as? String,
                        let status = game["status"] as? String {
                        gamesTheirMove.append(Game(id: id, title: title, icon: UIImage(named: icon)!, creator: Player(id: creatorID, name: creatorName), status: GameStatus(rawValue: status)!))
                    }
                }
                
                for game in completed {
                    if let id = game[JSON_KEY_ID] as? Int,
                        let title = game["title"] as? String,
                        let icon = game["icon"] as? String, // TODO: change to URL
                        let creatorID = game["creatorID"] as? Int,
                        let creatorName = game["creatorName"] as? String,
                        let status = game["status"] as? String {
                        gamesCompleted.append(Game(id: id, title: title, icon: UIImage(named: icon)!, creator: Player(id: creatorID, name: creatorName), status: GameStatus(rawValue: status)!))
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
            inviteCell.gameImageView.image = game.icon
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
        cell.gameImageView?.image = game.icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case TableViewSection.invites.rawValue:
            if (gamesInvites.isEmpty) {
                return nil
            }
            return "Invites"
        case TableViewSection.results.rawValue:
            if (gamesResults.isEmpty) {
                return nil
            }
            return "Results"
        case TableViewSection.activeGames.rawValue:
            return "Active Games"
        case TableViewSection.yourMove.rawValue:
            return "Your Move"
        case TableViewSection.theirMove.rawValue:
            return "Their Move"
        case TableViewSection.completedGames.rawValue:
            return "Completed Games"
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
        sectionTitleView.backgroundColor = COLOR_MINT_GREEN
        
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: tableView.frame.width, height: height))
        label.text = title
        label.font = font
        sectionTitleView.addSubview(label)
        
        return sectionTitleView
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
                    let constant = max(-deltaX, 8)
                    if (constant == 8) {
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
                    let constant = max(adjustment, 8)
                    if (activeCell.hideButtonsViewTrailingConstraint.constant == 8) {
                        activeCell.resetConstraintConstantsToZero(animated: false)
                        activeCell.isOpen = false
                        activeCell.acceptButton.isUserInteractionEnabled = false
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                }
            }
            activeCell.hideButtonsViewLeadingConstraint.constant = -activeCell.hideButtonsViewTrailingConstraint.constant + 16
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
