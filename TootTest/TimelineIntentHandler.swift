//
//  TimelineIntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/11/18.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation
import Intents
import os.log

class TimelineIntentHandler: NSObject, TimelineIntentHandling {
    var responseJson = Dictionary<String, AnyObject>()
    
    public func handle(intent: TimelineIntent, completion: @escaping (TimelineIntentResponse) -> Void) {
        completion(TimelineIntentResponse(code: .success, userActivity: nil))
    }
}
