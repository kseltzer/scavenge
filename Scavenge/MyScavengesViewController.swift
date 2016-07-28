//
//  MyScavengesViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class MyScavengesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func createNewGameButtonTapped(sender: UIBarButtonItem) {
        let createGameStoryboard = UIStoryboard(name: kCreateGameStoryboard, bundle: nil)
        let createGameViewController = createGameStoryboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(createGameViewController!, animated: true);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.backBarButtonItem = customBackBarItem(title: "")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SBaseTableViewCell
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! SBaseTableViewCell
            cell.gameTitleLabel.text = "Kim, Aliya, Sachin, Mahir"
            cell.gameStatusLabel.text = "your turn"
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! SBaseTableViewCell
            cell.gameTitleLabel.text = "Paul, Ryan, Jenny"
            cell.gameStatusLabel.text = "Ryan won"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Active Games"
        } else {
            return "Completed Games"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(playingGameViewController!, animated: true);
    }
    
}
