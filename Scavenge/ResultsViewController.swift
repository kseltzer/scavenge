//
//  ResultsViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ResultsCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var screenSize : CGRect!
    var cellWidth : CGFloat!
    var scrollViewOffsets : [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        screenSize = UIScreen.mainScreen().bounds
        cellWidth = screenSize.width - 16
        
        let topPadding : CGFloat = 8, bottomPadding : CGFloat = 8, playerLabelHeightAndPadding : CGFloat = 36
        
        let imageViewHeight = cellWidth * (8 / 7) / 2.5
        let cellHeight = imageViewHeight + topPadding + bottomPadding + playerLabelHeightAndPadding
        tableView.rowHeight = cellHeight
        tableView.scrollsToTop = true
        
        setupScrollViewOffsets()
    }
    
    func setupScrollViewOffsets() {
        let numPlayers = 5 // TODO: get data from backend
        for _ in 0..<numPlayers {
            scrollViewOffsets.append(0)
        }
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUM_GAME_QUESTIONS
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultsCell") as! ResultsCell
        cell.delegate = self
        cell.index = indexPath.section
        cell.scrollView.contentOffset = scrollViewOffsetForIndexPath(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRectMake(0, 0, cellWidth, 20))
        sectionHeaderView.backgroundColor = UIColor.whiteColor()
        let topicLabel = UILabel(frame: CGRectMake(8, 0, cellWidth, 20))
        topicLabel.text = "Topic" // TODO: hard coded data
        topicLabel.font = TABLE_VIEW_SUBSECTION_FONT
        sectionHeaderView.addSubview(topicLabel)
        return sectionHeaderView
    }
    
    func scrollViewOffsetForIndexPath(indexPath: NSIndexPath) -> CGPoint {
        let horizontalOffset = scrollViewOffsets[indexPath.section]
        return CGPointMake(horizontalOffset, 0)
    }
    
    // MARK: - ResultsCellDelegate
    func updateScrollPositionForIndexPath(scrollPosition scrollPosition: CGFloat, index: Int) {
        scrollViewOffsets[index] = scrollPosition
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
