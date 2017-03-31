//
//  BaseRequest.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 3/30/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BaseRequest: NSObject {
    let apiEndpointURL = "https://safe-castle-82849.herokuapp.com/api/v1"
    var completionBlock: ((_ response: JSON?, _ error: Any?) -> ())?
    func path() -> String {
        return ""
    }
    func params() -> [String: Any]? {
        return nil
    }

    func method() -> HTTPMethod {
        return HTTPMethod.get
    }
    
    func execute() {

        Alamofire.request(path(), method: method(), parameters: params(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            print("\n------------------------------------------------------")
            print("------------------------------------------------------")
            print("REQUEST:")
            print("\(response.request)")
            print("------------------------------------------------------")
            print("RESPONSE:")
            print("\(response.response)")
            print("------------------------------------------------------")
            print("RESULT:")
            print("\(response.result)")
            print("------------------------------------------------------")
            
            
            print("JSON:\n\(response.result.value)")
            print("------------------------------------------------------")
            print("------------------------------------------------------\n")
            
            if self.completionBlock != nil {
                if let responseValue = response.result.value {
                    let json = JSON(responseValue)
                    
                    if (json["error"] != JSON.null) {
                        self.completionBlock!(nil, json["error"])
                    } else {
                        self.completionBlock!(json, nil)
                    }
                }
                else {
                    self.completionBlock!(nil, "\(response.result.error)")
                }
            }
        })
    }

}
