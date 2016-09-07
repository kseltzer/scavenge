//
//  InviteViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/30/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import FBSDKCoreKit

let sampleData = ["Kim Seltzer", "Aliya Kamalova", "Albert Einstein", "Mahir Shah", "Rachel Green", "Ross Gellar", "Monica Gellar", "Joey Tribiani", "Chandler Bing", "Blaise Pascal",
"Dorothy Hodgkin", "Edwin Powell Hubble", "Gertrude B. Elion", "Johannes Kepler", "Marie Curie", "3SixMafia"]

class InviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    let interactor = InteractiveMenuTransition()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBarView: UIView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let indexTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z" ];
    var sectionTitles : [String] = []
    var sectionContents : [[String]] = []
    var contacts : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserFriends()
        configureSections()
        setupSearchController()
    }
    
    func getUserFriends() {
        let params = ["fields": "id, name, picture"]
        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error != nil {
                let errorMessage = error.localizedDescription
                print("Error: ", errorMessage)
            }
            else if result.isKindOfClass(NSDictionary){
                /* Handle response */
                print(result)
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
        contacts = sampleData.sort()
        for contact in contacts {
            if let firstLetterCharacter = contact.characters.first {
                let firstLetterString = String(firstLetterCharacter)
                if sectionTitles.contains(firstLetterString) {
                    sectionContents[sectionContents.count-1].append(contact)
                } else {
                    sectionTitles.append(firstLetterString)
                    sectionContents.append([contact])
                }
                
            }
        }
    }
    
    // MARK: - UISearchResultsUpdating Protocol
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if let index = sectionTitles.indexOf(title) {
            return index
        }
        let index = sectionTitles.count - 1
        return index >= 0 ? index : 0
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inviteCell", forIndexPath: indexPath) as! InviteCell
        cell.nameLabel.text = sectionContents[indexPath.section][indexPath.row]
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 35))
        customView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(8, 3, tableView.frame.width, 22))
        label.text = sectionTitles[section]
        label.textColor = UIColor.blueColor()
        customView.addSubview(label)
        
        return customView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContents[section].count // TODO: get data
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
