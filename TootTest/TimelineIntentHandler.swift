//
//  TimelineIntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/11/18.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation
import Intents

class TimelineIntentHandler: NSObject, TimelineIntentHandling {
    let api = APIController()
    var responseJson = Dictionary<String, AnyObject>()
    var dataList:[Toots] = []
    
    public func handle(intent: TimelineIntent, completion: @escaping (TimelineIntentResponse) -> Void) {
        let response = TimelineIntentResponse(code: .success, userActivity: nil)
        response.dataList = dataList as! [INObject]
        completion(response)
    }
}
