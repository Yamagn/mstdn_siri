//
//  IntentHandler.swift
//  TootTest
//
//  Created by ymgn on 2018/10/20.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

class IntentHandler: INExtension{
    
    override func handler(for intent: INIntent) -> Any? {
        switch intent {
        case is LetstootIntent:
            return LetstootIntentHandler()
        case is TimelineIntent:
            return TimelineIntentHandler()
        default:
            return nil
        }
    }
}
