//
//  IntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/09/22.
//  Copyright © 2018年 ymgn. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any? {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        switch intent {
        case is TootIntent:
            return TootIntentHandler()
        default:
            return nil
        }
    }
    
    class TootIntentHandler: NSObject, TootIntentHandling {
        func handle(intent: TootIntent, completion: @escaping (TootIntentResponse) -> Void) {
            guard let tootContent = intent.tootContent else {
                completion(TootIntentResponse(code: .failure, userActivity: nil))
                return
            }
            
            print(intent.tootContent)
            
            let response = TootIntentResponse.success(tootContent: tootContent)
            completion(response)
        }
    }
}
