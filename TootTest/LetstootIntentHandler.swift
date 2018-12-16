//
//  LetstootIntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/10/20.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation
import RealmSwift

class LetstootIntentHandler: NSObject ,LetstootIntentHandling {
    var responseJson = Dictionary<String, AnyObject>()
    
    func handle(intent: LetstootIntent, completion: @escaping (LetstootIntentResponse) -> Void) {
        guard let content = intent.content else {
            completion(LetstootIntentResponse(code: .inProgress, userActivity: nil))
            return
        }
        responseJson = api.tootWithToken(domain: Info.domain, content: content, access_token:Info.access_token)!
        completion(LetstootIntentResponse(code: .success, userActivity: nil))
    }
}
