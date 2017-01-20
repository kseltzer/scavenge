//
//  Game.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 12/27/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

enum GameStatus: String {
    case invite = "invite"
    case results = "results"
    case yourMove = "yourMove"
    case theirMove = "theirMove"
    case completed = "completed"
}

struct Game {
    var id: Int
    var title: String
    var icon: UIImage // todo: change to URL
    var creator: Player
    var status: GameStatus
    var players: [Player] = []
    var numPlayers: Int = 0
    var winner: Player? = nil
    var results: [TopicResults] = []
    var topicStrings: [String] = []
    
    init(id: Int, title: String, icon: UIImage /* todo: change to URL */, creator: Player, status: GameStatus) {
        self.id = id
        self.title = title
        self.icon = icon
        self.creator = creator
        self.status = status
    }
    
    init(id: Int, title: String, icon: UIImage /* todo: change to URL */, creator: Player, status: GameStatus, players: [Player], numPlayers: Int, winner: Player?, results: [TopicResults], topicStrings: [String]) {
        self.id = id
        self.title = title
        self.icon = icon
        self.creator = creator
        self.status = status
        self.players = players
        self.numPlayers = numPlayers
        self.winner = winner
        self.results = results
        self.topicStrings = topicStrings
    }
}

