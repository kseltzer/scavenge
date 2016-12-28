//
//  TopicResult.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 12/23/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation

struct TopicResult {
    var topic: String
    var submissions: [TopicSubmission]
    var winningSubmission: TopicSubmission?
}
