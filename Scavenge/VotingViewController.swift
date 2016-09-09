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


class VotingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VotingCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var scrollViewOffsets : [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let bottomSpace : CGFloat = 8
        let pageControlHeight : CGFloat = 37
        let imageViewHeight = cellWidth * IMAGE_RATIO
        tableView.rowHeight = imageViewHeight + bottomSpace + pageControlHeight
        tableView.scrollsToTop = true
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        setupScrollViewOffsets()
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
        let topicLabel = UILabel(frame: CGRectMake(leadingSpace, 0, cellWidth, 30))
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
        cell.delegate = self
        cell.index = indexPath.section
        cell.scrollView.contentOffset = scrollViewOffsetForIndexPath(indexPath)
        let pageNumber = round(cell.scrollView.contentOffset.x / cell.scrollView.frame.size.width)
        cell.pageControl.currentPage = Int(pageNumber)
        return cell
    }
    
    // MARK: - ResultsCellDelegate
    func setupScrollViewOffsets() {
        let numPlayers = 5 // TODO: get data from backend
        for _ in 0..<numPlayers {
            scrollViewOffsets.append(0)
        }
    }
    
    func scrollViewOffsetForIndexPath(indexPath: NSIndexPath) -> CGPoint {
        let horizontalOffset = scrollViewOffsets[indexPath.section]
        return CGPointMake(horizontalOffset, 0)
    }
    
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
