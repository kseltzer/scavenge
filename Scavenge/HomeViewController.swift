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

let invitationsDictionary : [String:AnyObject] = [:]

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, InvitationCellProtocol {

    let interactor = InteractiveTransitionController()
    @IBOutlet weak var tableView: UITableView!
    
    var activeInvitationCell : InvitationCell? = nil
    
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
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case TableViewSection.invites.rawValue:
            return 3
        case TableViewSection.results.rawValue:
            return 1
        case TableViewSection.activeGames.rawValue:
            return 0
        case TableViewSection.yourMove.rawValue:
            return 1
        case TableViewSection.theirMove.rawValue:
            return 1
        case TableViewSection.completedGames.rawValue:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameCell!
        switch ((indexPath as NSIndexPath).section) {
        case TableViewSection.invites.rawValue:
            let inviteCell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath) as! InvitationCell
            inviteCell.delegate = self
            return inviteCell
        case TableViewSection.results.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        case TableViewSection.activeGames.rawValue:
            return UITableViewCell()
        case TableViewSection.yourMove.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        case TableViewSection.theirMove.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        case TableViewSection.completedGames.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
            break
        default:
            return GameCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case TableViewSection.invites.rawValue:
            return "Invites"
        case TableViewSection.results.rawValue:
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
        sectionTitleView.backgroundColor = UIColor.white
        
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
                    invitationCell.resetConstraintConstantsToZero()
                    invitationCell.isOpen = false
                    invitationCell.acceptButton.isUserInteractionEnabled = false
                } else {
                    invitationCell.setConstraintsToShowAllButtons()
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
                    let constant = min(-deltaX, activeCell.getTotalButtonWidth())
                    if (constant == activeCell.getTotalButtonWidth()) {
                        activeCell.setConstraintsToShowAllButtons()
                        activeCell.isOpen = true
                        activeCell.acceptButton.isUserInteractionEnabled = true
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                } else {
                    let constant = max(-deltaX, 0)
                    if (constant == 0) {
                        activeCell.resetConstraintConstantsToZero()
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
                    let constant = min(adjustment, activeCell.getTotalButtonWidth())
                    if (constant == activeCell.getTotalButtonWidth()) {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                        activeCell.setConstraintsToShowAllButtons()
                        activeCell.isOpen = true
                        activeCell.acceptButton.isUserInteractionEnabled = true
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                } else {
                    let constant = max(adjustment, 0)
                    if (constant == 0) {
                        activeCell.resetConstraintConstantsToZero()
                        activeCell.isOpen = false
                        activeCell.acceptButton.isUserInteractionEnabled = false
                    } else {
                        activeCell.hideButtonsViewTrailingConstraint.constant = constant
                    }
                }
            }
            
            activeCell.hideButtonsViewLeadingConstraint.constant = -activeCell.hideButtonsViewTrailingConstraint.constant
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
                    activeCell.setConstraintsToShowAllButtons()
                    activeCell.isOpen = true
                    activeCell.acceptButton.isUserInteractionEnabled = true
                } else { // re-close
                    activeCell.resetConstraintConstantsToZero()
                    activeCell.isOpen = false
                    activeCell.acceptButton.isUserInteractionEnabled = false
                }
            } else { // cell was closing
                let rightButtonPlusHalfOfLeftButton = activeCell.acceptButton.frame.width + activeCell.declineButton.frame.width / 2
                if (activeCell.hideButtonsViewTrailingConstraint.constant >= rightButtonPlusHalfOfLeftButton) { // re-open all the way
                    activeCell.setConstraintsToShowAllButtons()
                } else { // close
                    activeCell.resetConstraintConstantsToZero()
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
                activeCell.resetConstraintConstantsToZero()
                activeCell.isOpen = false
                activeCell.acceptButton.isUserInteractionEnabled = false
            } else { // cell was open: reset to the open state
                activeCell.setConstraintsToShowAllButtons()
                activeCell.isOpen = true
                activeCell.acceptButton.isUserInteractionEnabled = true
            }
            activeInvitationCell = nil
            break
        default:
            break
        }
    }
    
    func acceptedGameInvite() {
        print("accepted")
    }
    
    func declinedGameInvite() {
        print("declined")
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
