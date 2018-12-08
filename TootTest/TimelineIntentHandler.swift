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
    let api = APIController()
    var responseJson = Dictionary<String, AnyObject>()
    let domain = "mstdn.maud.io"
    let mail = "syankenpon@gmail.com"
    let pass = "Tonarino10106"

    public func handle(intent: TimelineIntent, completion: @escaping (TimelineIntentResponse) -> Void) {
        responseJson = api.regist(domain: domain, responseJson: responseJson)!
        responseJson = api.loginAuth(domain: domain, mail: mail, pass: pass, responseJson: responseJson)!
        let dataList = api.getTl(domain: domain, responseJson: responseJson)
        if dataList.isEmpty {
            completion(TimelineIntentResponse(code: .inProgress, userActivity: nil))
        }
        intent.content = "aaa"
        completion(TimelineIntentResponse(code: .success, userActivity: nil))
    }
}
