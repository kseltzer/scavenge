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
        
        screenSize = UIScreen.main.bounds
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_GAME_QUESTIONS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell") as! ResultsCell
        cell.delegate = self
        cell.index = (indexPath as NSIndexPath).section
        cell.scrollView.contentOffset = scrollViewOffsetForIndexPath(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 20))
        sectionHeaderView.backgroundColor = UIColor.white
        let topicLabel = UILabel(frame: CGRect(x: 8, y: 0, width: cellWidth, height: 20))
        topicLabel.text = "Topic" // TODO: hard coded data
        topicLabel.font = TABLE_VIEW_SUBSECTION_FONT
        sectionHeaderView.addSubview(topicLabel)
        return sectionHeaderView
    }
    
    // MARK: - ResultsCellDelegate
    private func scrollViewOffsetForIndexPath(_ indexPath: IndexPath) -> CGPoint {
        let horizontalOffset = scrollViewOffsets[(indexPath as NSIndexPath).section]
        return CGPoint(x: horizontalOffset, y: 0)
    }
    
    func updateScrollPositionForIndexPath(scrollPosition: CGFloat, index: Int) {
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
