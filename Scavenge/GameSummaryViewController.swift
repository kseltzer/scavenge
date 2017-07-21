//
//  GameSummaryViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 3/3/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import UIKit

class GameSummaryViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {

    // MARK: - Outlets
    @IBOutlet var carouselView: iCarousel!
    @IBOutlet var playerView: UIView!
    @IBOutlet weak var profilePictureImageView: NetworkImageView!
    
    
    // MARK: - Constants
    let backgroundColors = [COLOR_GREENISH_BLUE, COLOR_RED, COLOR_YELLOW, COLOR_DARK_GREEN]
    
    
    // MARK: - Variables
    var game: Game! {
        didSet {
            self.updateUI()
        }
    }
    
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.dataSource = self
        carouselView.delegate = self
        
        carouselView.reloadData()
        carouselView.type = .rotary
    }
    
    func updateUI() {
        self.title = game.title
    }
    

    // MARK: - iCarousel Data Source
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.game.players.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let largeView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 480))
        
        let player = self.game.players[index]
        
        DispatchQueue.main.async {
            Bundle.main.loadNibNamed("SummaryCarouselView", owner:self, options:nil)
            
            var colorIndex = index
            if (colorIndex >= self.backgroundColors.count) {
                colorIndex = 0
            }
            self.playerView.backgroundColor = self.backgroundColors[colorIndex]
            
            self.playerView.frame = CGRect(x: 0, y: 30, width: 300, height: 450)
            self.profilePictureImageView.image_url = player.picture_url
            self.profilePictureImageView.contentMode = .scaleAspectFill
            self.profilePictureImageView.layoutIfNeeded()
            self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.height/2
            
            largeView.addSubview(self.playerView)
        }
        
        
        return largeView
    }
    
    @IBAction func nudgeButtonTapped(_ sender: SButton) {
        print("nudge")
        // TODO: Send notification to user
    }
    
    // MARK: - iCarousel Delegate
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.2
        }
        return value
    }
}
