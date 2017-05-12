//
//  GetFriendsRequest.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 5/5/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import Foundation
import Alamofire

class GetFriendsRequest: BaseRequest {
    var facebook_id: String
    var facebook_token: String
    
    init(facebook_id: String, facebook_token: String) {
        self.facebook_id = facebook_id
        self.facebook_token = facebook_token
    }
    
    override func path() -> String {
        return "\(apiEndpointURL)/user/\(self.facebook_id)/friends"
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    override func headers() -> HTTPHeaders? {
        return ["x-access-token": self.facebook_token]
    }
}
