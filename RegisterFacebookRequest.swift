//
//  RegisterFacebookRequest.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 3/30/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegisterFacebookRequest: BaseRequest {
    var facebook_id: String
    var facebook_token: String
    
    init(facebook_id: String, facebook_token: String) {
        self.facebook_id = facebook_id
        self.facebook_token = facebook_token
    }
    
    override func path() -> String {
        return "\(apiEndpointURL)/auth/facebook"
    }
    
    override func method() -> HTTPMethod {
        return .post
    }
    
    override func params() -> [String : Any]? {
        var params: [String: Any] = [:]
        params["userId"] = self.facebook_id
        params["accessToken"] = self.facebook_token
        return params
    }
}
