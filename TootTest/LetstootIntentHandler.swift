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
        guard let content = intent.content else {
            completion(LetstootIntentResponse(code: .failure, userActivity: nil))
            return
        }
        let api = APIController()
        var responseJson = Dictionary<String, AnyObject>()
        
        let domain = "mstdn.maud.io"
        let mail = "syankenpon@gmail.com"
        let pass = "Tonarino10106"
        
        responseJson = api.regist(domain: domain, responseJson: responseJson)!
        responseJson = api.loginAuth(domain: domain, mail: mail, pass: pass, responseJson: responseJson)!
        responseJson = api.toot(domain: domain, content: content, responseJson: responseJson)!
        completion(LetstootIntentResponse(code: .success, userActivity: nil))
    }
}