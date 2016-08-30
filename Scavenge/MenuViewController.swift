//
//  MenuViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/28/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuOptions = ["Home", "Invite", "Tour", "About", "Feedback", "Logout"]
    
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
        cell?.textLabel?.text = menuOptionTitleForRow(indexPath.row)
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch menuOptionTitleForRow(indexPath.row) {
            case "Home":
                self.performSegueWithIdentifier("showHome", sender: self)
                break
            case "Invite":
                self.performSegueWithIdentifier("showInvite", sender: self)
                break
            case "Tour":
                performSegueWithIdentifier("showTour", sender: self)
                break
            case "About":
                performSegueWithIdentifier("showAbout", sender: self)
                break
            case "Feedback":
                let alertController = UIAlertController(title: "Judge Us!", message: "Your feedback is important to us. We appreciate you rating and reviewing us in the app store.", preferredStyle: .Alert)
                let rateAction = UIAlertAction(title: "Rate", style: .Default) { (alert) in
                    // go to app store
                }
                let cancelAction = UIAlertAction(title: "Not Now", style: .Cancel, handler: nil)
                alertController.addAction(rateAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                break
            case "Logout":
                let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
                let logoutAction = UIAlertAction(title: "Yah", style: .Default) { (alert) in
                    // logout
                }
                let cancelAction = UIAlertAction(title: "Nah", style: .Cancel, handler: nil)
                alertController.addAction(logoutAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                break
            default:
                break
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func menuOptionTitleForRow(row: Int) -> String {
        return menuOptions[row]
    }
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func closeMenu(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
