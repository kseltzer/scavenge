//
//  InviteViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/30/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import FBSDKCoreKit

let INDEX_SECTION_TEXT_COLOR = UIColor.black
let INDEX_DEFAULT_BACKGROUND_COLOR = UIColor.lightGray
let INDEX_HIGHLIGHTED_BACKGROUND_COLOR = UIColor.gray

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
    var invitedFriendsIndices: [IndexPath] = []
    
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
        let connection = FBSDKGraphRequestConnection()
        connection.add(request, completionHandler: { (connection, result, error) in
            
            if error != nil {
                let errorMessage = error?.localizedDescription
                print("Error: ", errorMessage)
            } else if let resultDict = result as? NSDictionary {
                if let resultArray = resultDict["data"] as? [[String:Any]] {
                    for friend in resultArray {
                        if let  name = friend["name"] as? String, let id = friend["id"] as? String {
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
                self.fbFriends.sort(by: { $0.name < $1.name })
                self.configureSections()
            }
        })
        
        connection.start()
//        request?.start { (connection, result, error) -> Void in
//            
//            if error != nil {
//                let errorMessage = error?.localizedDescription
//                print("Error: ", errorMessage)
//            }
//            else if let resultDict = result as? NSDictionary {
//                if let resultArray = resultDict["data"] as? NSArray {
//                    for friend in resultArray {
//                        if let  name = friend["name"] as? String, let id = friend["id"] as? String {
//                            var hasNegativeStateImage : Bool = false, url : String? = nil
//                            if let pictureDict = friend["picture"] as? NSDictionary {
//                                if let pictureData = pictureDict["data"] as? NSDictionary {
//                                    hasNegativeStateImage = (pictureData["is_silhouette"] as? Bool)!
//                                    url = pictureData["url"] as? String
//                                }
//                            }
//                            let contact = FacebookInviteFriend(name: name, id: id, profileImageURL: url, hasNegativeStateImage: hasNegativeStateImage, invited: false)
//                            self.fbFriends.append(contact)
//                        }
//                    }
//                }
//                self.fbFriends.sort(by: { $0.name < $1.name })
//                self.configureSections()
//            }
//        }
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
        
        if (searchController.isActive && searchController.searchBar.text != "") {
            friendsList = filteredFBFriends
        } else {
            friendsList = fbFriends
        }
        
        var nonAlphabetList : [FacebookInviteFriend] = []
        for contact in friendsList {
            if let firstLetterCharacter = contact.name.characters.first {
                let firstLetterString = String(firstLetterCharacter)
                if (indexTitles.index(of: firstLetterString) == nil) || (indexTitles.index(of: firstLetterString) == indexTitles.count-1) { // first letter is a #
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
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let index = sectionTitles.index(of: title) {
            return index
        }

        // if no contents in section, return index of nearest non-empty section
        if let _ = indexTitles.index(of: title) {
            // check preceeding sections
            var entireAlphabetIndex = indexTitles.index(of: title)!
            var returnIndex : Int? = nil
            var closestLetter : String? = nil
            while entireAlphabetIndex >= 0 && returnIndex == nil {
                closestLetter = indexTitles[entireAlphabetIndex]
                returnIndex = sectionTitles.index(of: closestLetter!)
                entireAlphabetIndex -= 1
            }
            if returnIndex != nil {
                return returnIndex!
            }
            
            // check following sections
            entireAlphabetIndex = indexTitles.index(of: title)!
            returnIndex = nil
            closestLetter = nil
            while entireAlphabetIndex < indexTitles.count && returnIndex == nil {
                closestLetter = indexTitles[entireAlphabetIndex]
                returnIndex = sectionTitles.index(of: closestLetter!)
                entireAlphabetIndex += 1
            }
            if returnIndex != nil {
                return returnIndex!
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        invitedFriendsIndices.append(indexPath)
        let cell = tableView.cellForRow(at: indexPath) as! InviteCell
        cell.setSelectedAppearance()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFBFriends = []
        filteredFBFriends = fbFriends.filter { friend in
            return friend.name.lowercased().contains(searchText.lowercased())
        }
        
        configureSections()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath) as! InviteCell
        let friend = sectionContents[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        cell.nameLabel.text = friend.name
        
        if let urlString = friend.profileImageURL {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async(execute: {
                        cell.profileImage.image = UIImage(data: data)
                    });
                }
            }
        } else {
            // set cell.profileImage to negativeState
        }
        
        if invitedFriendsIndices.index(of: indexPath) != nil {
            cell.setSelectedAppearance()
        } else {
            cell.setDeselectedAppearance()
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        customView.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 8, y: 3, width: tableView.frame.width, height: 22))
        label.text = sectionTitles[section]
        label.textColor = INDEX_SECTION_TEXT_COLOR
        customView.addSubview(label)
        
        return customView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    @IBAction func handleEdgeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.performSegue(withIdentifier: kShowMenuSegue, sender: self)
        }
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.performSegue(withIdentifier: kShowMenuSegue, sender: self)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideMenuAnimator()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.currentScreen = .Invite
        }
    }
}
