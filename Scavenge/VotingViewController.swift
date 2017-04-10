//
//  VotingViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/6/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit


let screenSize: CGRect = UIScreen.main.bounds
let leadingSpace : CGFloat = 8, trailingSpace : CGFloat = 8
let cellWidth = screenSize.width - (leadingSpace + trailingSpace)

let dummyContentImagesFromBackend = [UIImage(named: "aliya"), UIImage(named: "sachin"), UIImage(named: "paul")] // TODO: delete this line

class VotingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VotingCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var hasSubmittedAllVotes : Bool = false
    var scrollViewOffsets : [CGFloat] = []
    var votedImagesArray : [UIImage?] = []
    
    var images : [[UIImage]] = [] // TODO: get data from backend
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollsToTop = true
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        setupScrollViewOffsets()
        setupVotedImagesArray()
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_GAME_QUESTIONS + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == NUM_GAME_QUESTIONS) {
            return nil
        }
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 30))
        sectionHeaderView.backgroundColor = UIColor.white
        let topicLabel = UILabel(frame: CGRect(x: leadingSpace, y: 0, width: cellWidth, height: 30))
        topicLabel.text = "Topic" // TODO: get data from backend
//        topicLabel.textColor = UIColor.white
        topicLabel.font = VOTING_TABLE_VIEW_SECTION_FONT
        sectionHeaderView.addSubview(topicLabel)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section >= NUM_GAME_QUESTIONS {
            let buttonHeight : CGFloat = 55
            let topSpace : CGFloat = 8, bottomSpace : CGFloat = 32
            return buttonHeight + topSpace + bottomSpace
        }
        
        let bottomSpace : CGFloat = 8
        let pageControlHeight : CGFloat = 37
        let imageViewHeight = cellWidth * IMAGE_RATIO
        let rowHeight = imageViewHeight + bottomSpace + pageControlHeight
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= NUM_GAME_QUESTIONS {
            return 0
        }
        
        return 30
    }
    
    
    
    func configureSubmitCell(_ cell: SubmitCell) -> SubmitCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToResultsViewController))
        cell.submitButton.addGestureRecognizer(tapGesture)
        if (self.hasSubmittedAllVotes) {
            cell.submitButton.isEnabled = true
                cell.submitButton.alpha = 1.0
            } else {
            cell.submitButton.isEnabled = false
                cell.submitButton.alpha = 0.6
            }
        return cell
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section >= NUM_GAME_QUESTIONS {
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitCell") as! SubmitCell
            return configureSubmitCell(cell)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photosForTopicCell") as! VotingCell
        cell.delegate = self
        cell.index = (indexPath as NSIndexPath).section
        cell.images = dummyContentImagesFromBackend as! [UIImage] // TODO: get data from images array, which gets data from backend
        cell.scrollView.contentOffset = scrollViewOffsetForIndexPath(indexPath)
        let pageNumber = round(cell.scrollView.contentOffset.x / cell.scrollView.frame.size.width)
        cell.pageControl.currentPage = Int(pageNumber)
        cell.updateUIForVotingState()
        return cell
    }
    
    // MARK: - ResultsCellDelegate
    func setupScrollViewOffsets() {
        let numPlayers = 5 // TODO: get data from backend
        for _ in 0..<numPlayers {
            scrollViewOffsets.append(0)
        }
    }
    
    private func scrollViewOffsetForIndexPath(_ indexPath: IndexPath) -> CGPoint {
        let horizontalOffset = scrollViewOffsets[(indexPath as NSIndexPath).section]
        return CGPoint(x: horizontalOffset, y: 0)
    }
    
    func updateScrollPositionForIndexPath(scrollPosition: CGFloat, index: Int) {
        scrollViewOffsets[index] = scrollPosition
    }
    
    func setupVotedImagesArray() {
        for _ in 0..<NUM_GAME_QUESTIONS {
            votedImagesArray.append(nil)
        }
    }
    
    func updateVoteForImageAtIndexPath(_ image: UIImage?, index: Int) {
        votedImagesArray[index] = image
        hasSubmittedAllVotes = true
        for row in 0..<NUM_GAME_QUESTIONS {
            if (votedImagesArray[row] == nil) {
                hasSubmittedAllVotes = false
            }
        }
        tableView.reloadSections(IndexSet(integer: NUM_GAME_QUESTIONS), with: .none)
    }
    
    func hasVotedAtIndexPath(_ index: Int) -> Bool {
        return votedImagesArray[index] !== nil
    }

    // MARK: - Navigation
    func goToResultsViewController() {
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let resultsViewController = playingGameStoryboard.instantiateViewController(withIdentifier: kGameResultsViewController)
        navigationController?.replaceStackWithViewController(destinationViewController: resultsViewController)
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
