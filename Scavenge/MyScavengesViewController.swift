//
//  MyScavengesViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

enum TableViewSection : Int {
    case Invites = 0
    case Results = 1
    case ActiveGames = 2
    case YourMove = 3
    case TheirMove = 4
    case CompletedGames = 5
}

enum SectionType {
    case Main
    case Subsection
}

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
        tableView.rowHeight = 85
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case TableViewSection.Invites.rawValue:
            return 3
        case TableViewSection.Results.rawValue:
            return 1
        case TableViewSection.ActiveGames.rawValue:
            return 0
        case TableViewSection.YourMove.rawValue:
            return 1
        case TableViewSection.TheirMove.rawValue:
            return 1
        case TableViewSection.CompletedGames.rawValue:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SBaseTableViewCell
        switch (indexPath.section) {
        case TableViewSection.Invites.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("threePlayerCell") as! SBaseTableViewCell
//            cell.gameTitleLabel.text = "Kim, Sachin, Aliya"
//            cell.gameStatusLabel.text = "your turn"
            break
        case TableViewSection.Results.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("fourPlayerCell") as! SBaseTableViewCell
//            cell.gameTitleLabel.text = "Kim, Sachin, Aliya"
//            cell.gameStatusLabel.text = "your turn"
            break
        case TableViewSection.ActiveGames.rawValue:
            return UITableViewCell()
        case TableViewSection.YourMove.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("threePlayerCell") as! SBaseTableViewCell
//            cell.gameTitleLabel.text = "Kim, Sachin, Aliya Move"
//            cell.gameStatusLabel.text = "your turn"
            break
        case TableViewSection.TheirMove.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("fivePlayerCell") as! SBaseTableViewCell
//            cell.gameTitleLabel.text = "Kim, Sachin, Aliya Move"
//            cell.gameStatusLabel.text = "your turn"
            break
        case TableViewSection.CompletedGames.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("gameCell") as! SBaseTableViewCell
//            cell.gameTitleLabel.text = "Kim, Sachin, Aliya"
//            cell.gameStatusLabel.text = "your turn"
            break
        default:
            return SBaseTableViewCell()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case TableViewSection.Invites.rawValue:
            return "Invites"
        case TableViewSection.Results.rawValue:
            return "Results"
        case TableViewSection.ActiveGames.rawValue:
            return "Active Games"
        case TableViewSection.YourMove.rawValue:
            return "Your Move"
        case TableViewSection.TheirMove.rawValue:
            return "Their Move"
        case TableViewSection.CompletedGames.rawValue:
            return "Completed Games"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle : String!
        var sectionType : SectionType!
        switch (section) {
        case TableViewSection.Invites.rawValue:
            sectionTitle = kSectionTitleInvites
            sectionType = .Main
        case TableViewSection.Results.rawValue:
            sectionTitle = kSectionTitleResults
            sectionType = .Main
        case TableViewSection.ActiveGames.rawValue:
            sectionTitle = kSectionTitleActiveGames
            sectionType = .Main
        case TableViewSection.YourMove.rawValue:
            sectionTitle = kSubsectionTitleYourMove
            sectionType = .Subsection
        case TableViewSection.TheirMove.rawValue:
            sectionTitle = kSubsectionTitleTheirMove
            sectionType = .Subsection
        case TableViewSection.CompletedGames.rawValue:
            sectionTitle = kSectionTitleCompletedGames
            sectionType = .Main
        default:
            sectionTitle = ""
        }
        
        return viewForHeaderInSectionWithTitle(sectionType, title: sectionTitle)
    }
    
    func viewForHeaderInSectionWithTitle(sectionType: SectionType, title: String) -> UIView {
        var height : CGFloat!
        var font : UIFont!
        if sectionType == .Main {
            height = 26
            font = TABLE_VIEW_SECTION_FONT
        } else if sectionType == .Subsection {
            height = 18
            font = TABLE_VIEW_SUBSECTION_FONT
        }
        
        let sectionTitleView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, height))
        sectionTitleView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(8, 0, tableView.frame.width, height))
        label.text = title
        label.font = font
        sectionTitleView.addSubview(label)
        
        return sectionTitleView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let playingGameViewController = playingGameStoryboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(playingGameViewController!, animated: true);
    }
    
}
