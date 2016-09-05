//
//  VotingViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/6/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit


let screenSize: CGRect = UIScreen.mainScreen().bounds
let leadingSpace : CGFloat = 8, trailingSpace : CGFloat = 8
let cellWidth = screenSize.width - (leadingSpace + trailingSpace)
let imageViewHeight = cellWidth * IMAGE_RATIO
let cellHeight = imageViewHeight + 28 + 35 + 12

class VotingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let bottomSpace : CGFloat = 8
        let pageControlHeight : CGFloat = 37
        tableView.rowHeight = imageViewHeight + bottomSpace + pageControlHeight
        tableView.scrollsToTop = true
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUM_GAME_QUESTIONS
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRectMake(0, 0, cellWidth, 30))
        sectionHeaderView.backgroundColor = UIColor.whiteColor()
        let topicLabel = UILabel(frame: CGRectMake(8, 0, cellWidth, 30))
        topicLabel.text = "Topic" // TODO: get data from backend
        topicLabel.font = VOTING_TABLE_VIEW_SECTION_FONT
        sectionHeaderView.addSubview(topicLabel)
        return sectionHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("photosForTopicCell") as! VotingCell
        return cell
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
