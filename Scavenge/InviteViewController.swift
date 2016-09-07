//
//  InviteViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/30/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import FBSDKCoreKit

let INDEX_SECTION_TEXT_COLOR = UIColor.blackColor()
let INDEX_DEFAULT_BACKGROUND_COLOR = UIColor.lightGrayColor()
let INDEX_HIGHLIGHTED_BACKGROUND_COLOR = UIColor.grayColor()

class InviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    let interactor = InteractiveMenuTransition()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBarView: UIView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let indexTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z", "#"];
    var sectionTitles : [String] = []
    var sectionContents : [[FacebookInviteFriend]] = []
    var fbFriends : [FacebookInviteFriend] = []
    var filteredFBFriends : [FacebookInviteFriend] = []
    var invitedFriendsIndices: [NSIndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableViewIndex()
        setupSearchController()
        getUserFriends()
    }
    
    func getUserFriends() {
        let params = ["fields": "id, name, picture"]
        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends?limit=5000", parameters: params)
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error != nil {
                let errorMessage = error.localizedDescription
                print("Error: ", errorMessage)
            }
            else if let resultDict = result as? NSDictionary {
                if let resultArray = resultDict["data"] as? NSArray {
                    for friend in resultArray {
                        if let  name = friend["name"] as? String, id = friend["id"] as? String {
                            var hasNegativeStateImage : Bool = false, url : String? = nil
                            if let pictureDict = friend["picture"] as? NSDictionary {
                                if let pictureData = pictureDict["data"] as? NSDictionary {
                                    hasNegativeStateImage = (pictureData["is_silhouette"] as? Bool)!
                                    url = pictureData["url"] as? String
                                }
                            }
                            let contact = FacebookInviteFriend(name: name, id: id, profileImageURL: url, hasNegativeStateImage: hasNegativeStateImage, invited: false)
                            self.fbFriends.append(contact)
                        }
                    }
                }
                self.fbFriends.sortInPlace({ $0.name < $1.name })
                self.configureSections()
            }
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
    
    func configureSections() {
        var friendsList : [FacebookInviteFriend] = []
        sectionTitles = []
        sectionContents = []
        
        if (searchController.active && searchController.searchBar.text != "") {
            friendsList = filteredFBFriends
        } else {
            friendsList = fbFriends
        }
        
        var nonAlphabetList : [FacebookInviteFriend] = []
        for contact in friendsList {
            if let firstLetterCharacter = contact.name.characters.first {
                let firstLetterString = String(firstLetterCharacter)
                if (indexTitles.indexOf(firstLetterString) == nil) || (indexTitles.indexOf(firstLetterString) == indexTitles.count-1) { // first letter is a #
                    nonAlphabetList.append(contact)
                } else if sectionTitles.contains(firstLetterString) {
                    sectionContents[sectionContents.count-1].append(contact)
                } else {
                    sectionTitles.append(firstLetterString)
                    sectionContents.append([contact])
                }
                
            }
        }
        if !nonAlphabetList.isEmpty {
            sectionTitles.append("#")
            sectionContents.append(nonAlphabetList)
        }
        tableView.reloadData()
    }
    
    func setupTableViewIndex() {
        tableView.sectionIndexColor = INDEX_SECTION_TEXT_COLOR
        tableView.sectionIndexBackgroundColor = INDEX_DEFAULT_BACKGROUND_COLOR
        tableView.sectionIndexTrackingBackgroundColor = INDEX_HIGHLIGHTED_BACKGROUND_COLOR
    }
    
    // MARK: - UISearchResultsUpdating Protocol
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if let index = sectionTitles.indexOf(title) {
            return index
        }

        // if no contents in section, return index of nearest non-empty section
        if let _ = indexTitles.indexOf(title) {
            // check preceeding sections
            var entireAlphabetIndex = indexTitles.indexOf(title)!
            var returnIndex : Int? = nil
            var closestLetter : String? = nil
            while entireAlphabetIndex >= 0 && returnIndex == nil {
                closestLetter = indexTitles[entireAlphabetIndex]
                returnIndex = sectionTitles.indexOf(closestLetter!)
                entireAlphabetIndex -= 1
            }
            if returnIndex != nil {
                return returnIndex!
            }
            
            // check following sections
            entireAlphabetIndex = indexTitles.indexOf(title)!
            returnIndex = nil
            closestLetter = nil
            while entireAlphabetIndex < indexTitles.count && returnIndex == nil {
                closestLetter = indexTitles[entireAlphabetIndex]
                returnIndex = sectionTitles.indexOf(closestLetter!)
                entireAlphabetIndex += 1
            }
            if returnIndex != nil {
                return returnIndex!
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        invitedFriendsIndices.append(indexPath)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredFBFriends = []
        filteredFBFriends = fbFriends.filter { friend in
            return friend.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        configureSections()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inviteCell", forIndexPath: indexPath) as! InviteCell
        let friend = sectionContents[indexPath.section][indexPath.row]
        cell.nameLabel.text = friend.name
        
        if let urlString = friend.profileImageURL {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if let url = NSURL(string: urlString), data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.profileImage.image = UIImage(data: data)
                    });
                }
            }
        } else {
            // set cell.profileImage to negativeState
        }
        
        if invitedFriendsIndices.indexOf(indexPath) != nil {
            cell.setSelectedAppearance()
        } else {
            cell.setDeselectedAppearance()
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 35))
        customView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(8, 3, tableView.frame.width, 22))
        label.text = sectionTitles[section]
        label.textColor = INDEX_SECTION_TEXT_COLOR
        customView.addSubview(label)
        
        return customView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContents[section].count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InviteViewController: UIViewControllerTransitioningDelegate {
    
    @IBAction func handleEdgeGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .Right)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.performSegueWithIdentifier(kShowMenuSegue, sender: self)
        }
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .Right)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.performSegueWithIdentifier(kShowMenuSegue, sender: self)
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowMenuAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideMenuAnimator()
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.currentScreen = .Invite
        }
    }
}
