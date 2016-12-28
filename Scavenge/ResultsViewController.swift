//
//  ResultsViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

let dummyPlayer1 = Player(id: "1", firstName: "Kim", name: "Kim Seltzer")
let dummyPlayer2 = Player(id: "2", firstName: "Aliya", name: "Aliya Kamalova")
let dummyPlayer3 = Player(id: "3", firstName: "Mahir", name: "Mahir Shah")
let dummyPlayer4 = Player(id: "4", firstName: "Sachin", name: "Sachin Medhekar")
let dummyPlayer5 = Player(id: "5", firstName: "Ian", name: "Ian Abramson")

let dummySubmission1 = TopicSubmission(image: UIImage(named: "aliya")!, submittedBy: dummyPlayer1, numVotes: 3)
let dummySubmission2 = TopicSubmission(image: UIImage(named: "paul")!, submittedBy: dummyPlayer2, numVotes: 0)
let dummySubmission3 = TopicSubmission(image: UIImage(named: "sachin")!, submittedBy: dummyPlayer3, numVotes: 1)
let dummySubmission4 = TopicSubmission(image: UIImage(named: "fbProfilePic")!, submittedBy: dummyPlayer4, numVotes: 1)
let dummySubmission5 = TopicSubmission(image: UIImage(named: "raccoon")!, submittedBy: dummyPlayer5, numVotes: 0)

let dummyResultsData: [TopicResult] = [TopicResult(topic: "Unconventionally Ugly", submissions: [dummySubmission1, dummySubmission2, dummySubmission3, dummySubmission4, dummySubmission5], winningSubmission: nil)]

let dummyGameData = Game(players: [dummyPlayer1, dummyPlayer2, dummyPlayer3], numPlayers: 5, winner: dummyPlayer4, status: .completed, results: dummyResultsData, topicStrings: ["Unconventionally Ugly", "So Crazy It Just Might Work", "Nostalgia", "WTF", "Haunted As Shit"])

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
        let numPlayers = dummyGameData.numPlayers // TODO: get data from backend
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
        topicLabel.text = dummyGameData.topicStrings[section] // TODO: get data from backend
        topicLabel.font = TABLE_VIEW_SUBSECTION_FONT
        sectionHeaderView.addSubview(topicLabel)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RESULTS_TABLE_VIEW_SECTION_HEIGHT
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
