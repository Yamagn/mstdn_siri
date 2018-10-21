//
//  LetstootIntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/10/20.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation

class LetstootIntentHandler: NSObject ,LetstootIntentHandling {
    func handle(intent: LetstootIntent, completion: @escaping (LetstootIntentResponse) -> Void) {
        completion(LetstootIntentResponse(code: .success, userActivity: nil))
    }
}
