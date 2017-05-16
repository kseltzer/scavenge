//
//  SubmitPhotoToGameRequest.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 5/12/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SubmitPhotosToGameRequest: BaseRequest {
    var facebook_id: String
    var facebook_token: String
    var game_id: String
    var photos: [String]
    
    init(facebook_id: String, facebook_token: String, game_id: String, photos: [String]) {
        self.facebook_id = facebook_id
        self.facebook_token = facebook_token
        self.game_id = game_id
        self.photos = photos
    }
    
    override func path() -> String {
        return "\(apiEndpointURL)/user/\(self.facebook_id)/games/\(game_id)"
    }
    
    override func method() -> HTTPMethod {
        return .put
    }
    
    override func headers() -> HTTPHeaders? {
        return ["x-access-token": self.facebook_token]
    }
    
    override func params() -> [String: Any]? {
        var arr: [JSON] = []
        
        
        for fileName in self.photos {
            arr.append(JSON(stringLiteral: "{\"bucket\": \(AWS_BUCKET), \"fileName\": \(fileName)}"))
        }
        
        print("arr: ", arr)
        
//        return ["pictures": ]
        return nil
    }
}

