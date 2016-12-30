//
//  Game.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 12/27/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation

enum GameStatus {
    case active
    case completed
}

struct Game {
    var players: [Player]
    var numPlayers: Int
    var winner: Player?
    var status: GameStatus
    var results: [TopicResults]
    var topicStrings: [String]
}
