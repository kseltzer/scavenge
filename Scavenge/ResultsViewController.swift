//
//  ResultsViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let cellWidth = screenSize.width - 16
        
        let topPadding : CGFloat = 8, bottomPadding : CGFloat = 8, topicLabelHeightAndPadding : CGFloat = 28, playerLabelHeightAndPadding : CGFloat = 36
        
        let imageViewHeight = cellWidth * (8 / 7) / 2.5
        let cellHeight = imageViewHeight + topPadding + bottomPadding + topicLabelHeightAndPadding + playerLabelHeightAndPadding
        tableView.rowHeight = cellHeight
        tableView.scrollsToTop = true
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultsCell") as! ResultsCell
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
