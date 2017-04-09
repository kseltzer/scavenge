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
    case Help = "Help"
    case About = "About"
    case Feedback = "Feedback"
    case Logout = "Logout"
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var menuBackgroundImageView: UIImageView!
    
    let menuOptions : [MenuOption] = [.Home, .Invite, .Help, .About, .Feedback, .Logout]
    var currentScreen : MenuOption?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        firstNameLabel.text = UserDefaults.standard.value(forKey: KEY_FIRST_NAME) as? String
        lastNameLabel.text = UserDefaults.standard.value(forKey: KEY_LAST_NAME) as? String
        
        menuBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        menuBackgroundImageView.layer.borderWidth = 16
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let fileManager = FileManager.default
        let imagePath = (documentsDirectory as NSString).appendingPathComponent("profileImage.png")
        if fileManager.fileExists(atPath: imagePath){
            self.profileImageView.image = UIImage(contentsOfFile: imagePath)
        } else{
            print("No profile image available")
        }
    }
    
    var interactor: InteractiveTransitionController? = nil
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell {
            let option = menuOptionForRow((indexPath as NSIndexPath).row)
            cell.menuOption = option
            if option == currentScreen && option != .Feedback && option != .Logout {
                cell.isCurrentScreen = true
            } else {
                cell.isCurrentScreen = false
            }
            cell.pageTitleLabel.text = option.rawValue
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let menuOption = menuOptionForRow((indexPath as NSIndexPath).row)
        switch menuOption {
            case .Home, .Invite, .Help, .About:
                self.performSegue(withIdentifier: "show\(menuOption.rawValue)", sender: self)
                break
            case .Feedback:
                let alertController = UIAlertController(title: "Judge Us!", message: "Your feedback is important to us. We appreciate you rating and reviewing us in the app store.", preferredStyle: .alert)
                let rateAction = UIAlertAction(title: "Rate", style: .default) { (alert) in
                    // go to app store
                }
                let cancelAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
                alertController.addAction(rateAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                break
            case .Logout:
                let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                let logoutAction = UIAlertAction(title: "Yah", style: .default) { (alert) in
                    // logout
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                    let loginStoryboard = UIStoryboard(name: kLoginStoryboard, bundle: nil)
                    let loginViewController = loginStoryboard.instantiateInitialViewController()
                    self.present(loginViewController!, animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "Nah", style: .cancel, handler: nil)
                alertController.addAction(logoutAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func menuOptionForRow(_ row: Int) -> MenuOption {
        return menuOptions[row]
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - Slideout Menu

extension MenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RightToLeftAnimator()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
    }
}
