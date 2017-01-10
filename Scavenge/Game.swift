//
//  Game.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 12/27/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

enum GameStatus {
    case invite
    case results
    case yourMove
    case theirMove
    case completed
}

struct Game {
    var id: Int
    var title: String
    var icon: UIImage // todo: change to URL
    var creator: Player
    var players: [Player]
    var numPlayers: Int
    var winner: Player?
    var status: GameStatus
    var results: [TopicResults]
    var topicStrings: [String]
}
