//
//  MenuViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/28/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

enum MenuOption : String {
    case Home = "Home"
    case Invite = "Invite"
    case Tour = "Tour"
    case About = "About"
    case Feedback = "Feedback"
    case Logout = "Logout"
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuOptions : [MenuOption] = [.Home, .Invite, .Tour, .About, .Feedback, .Logout]
    var currentScreen : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    var interactor: InteractiveMenuTransition? = nil
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .Left)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell")
        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.textColor = UIColor.groupTableViewBackgroundColor()
        cell?.textLabel?.text = menuOptionForRow(indexPath.row).rawValue
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let menuOption = menuOptionForRow(indexPath.row)
        switch menuOption {
            case .Home, .Invite, .Tour, .About:
                self.performSegueWithIdentifier("show\(menuOption.rawValue)", sender: self)
                break
            case .Feedback:
                let alertController = UIAlertController(title: "Judge Us!", message: "Your feedback is important to us. We appreciate you rating and reviewing us in the app store.", preferredStyle: .Alert)
                let rateAction = UIAlertAction(title: "Rate", style: .Default) { (alert) in
                    // go to app store
                }
                let cancelAction = UIAlertAction(title: "Not Now", style: .Cancel, handler: nil)
                alertController.addAction(rateAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                break
            case .Logout:
                let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
                let logoutAction = UIAlertAction(title: "Yah", style: .Default) { (alert) in
                    // logout
                }
                let cancelAction = UIAlertAction(title: "Nah", style: .Cancel, handler: nil)
                alertController.addAction(logoutAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                break
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func menuOptionForRow(row: Int) -> MenuOption {
        return menuOptions[row]
    }
    
    @IBAction func closeMenu(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - Slideout Menu

extension MenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RightToLeftAnimator()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.transitioningDelegate = self
    }
}
