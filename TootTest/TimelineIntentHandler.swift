//
//  TimelineIntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/11/18.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation

class TimelineIntentHandler: NSObject, TimelineIntentHandling {
    let api = APIController()
    var responseJson = Dictionary<String, AnyObject>()
    
    let domain = "mstdn.maud.io"
    
    func handle(intent: TimelineIntent, completion: @escaping (TimelineIntentResponse) -> Void) {
        if let res = api.getTl(domain: domain, responseJson: responseJson) {
            responseJson = res
        } else {
            completion(TimelineIntentResponse(code: .failure, userActivity: nil))
        }
        completion(TimelineIntentResponse(code: .success, userActivity: nil))
    }
}
