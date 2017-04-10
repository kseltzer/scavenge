//
//  GameSummaryViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 3/3/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import UIKit

class GameSummaryViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {
    @IBOutlet var carouselView: iCarousel!
    @IBOutlet var playerView: UIView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    let backgroundColors = [COLOR_ORANGE, COLOR_DARK_GREEN, COLOR_YELLOW, COLOR_ORANGE, COLOR_DARK_GREEN]
    let items: [UIImage] = [UIImage(named: "aliya")!, UIImage(named: "sachin")!, UIImage(named: "ian")!, UIImage(named: "paul")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.dataSource = self
        carouselView.delegate = self
        
        carouselView.reloadData()
        carouselView.type = .rotary
    }

    // MARK: - iCarousel Data Source
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let largeView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 480))
        
        DispatchQueue.main.async {
            Bundle.main.loadNibNamed("SummaryCarouselView", owner:self, options:nil)
            self.playerView.frame = CGRect(x: 0, y: 30, width: 300, height: 450)
//            self.playerView.backgroundColor = backgroundColors[index]
            self.playerView.backgroundColor = COLOR_LIGHT_BROWN
            self.profilePictureImageView.image = UIImage(named: "paul")
            self.profilePictureImageView.contentMode = .scaleAspectFill
            self.profilePictureImageView.layoutIfNeeded()
            self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.height/2
            largeView.addSubview(self.playerView)
        }
        
        
        return largeView
        
//        var itemView: UIImageView
//        
//        let largeView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 400))
//        
//        largeView.backgroundColor = backgroundColors[index]
//        
//        //reuse view if available, otherwise create a new view
//        if let view = view as? UIImageView {
//            itemView = view
//            //get a reference to the label in the recycled view
//        } else {
//            //don't do anything specific to the index within
//            //this `if ... else` statement because the view will be
//            //recycled and used with other index values later
//            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
//            itemView.image = items[index]
//            itemView.contentMode = .scaleAspectFill
//        }
//        
//        //remember to always set any properties of your carousel item
//        //views outside of the `if (view == nil) {...}` check otherwise
//        //you'll get weird issues with carousel item content appearing
//        //in the wrong place in the carousel
//        
//        largeView.addSubview(itemView)
//        return largeView
    }
    
    @IBAction func nudgeButtonTapped(_ sender: SButton) {
        print("nudge")
    }
    
    // MARK: - iCarousel Delegate
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.2
        }
        return value
    }
}
