//
//  IntentViewController.swift
//  TootTestUI
//
//  Created by ymgn on 2018/10/21.
//  Copyright © 2018 ymgn. All rights reserved.
//

import IntentsUI
import Intents

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var domainText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        guard interaction.intent is LetstootIntent else {
            completion(false, Set(), .zero)
            return
        }
        
        if interaction.intentHandlingStatus == .ready {
        }
        else if interaction.intentHandlingStatus == .success {
            completion(true, parameters, self.desiredSize)
        }
    }
    
    @IBAction func tootButton(_ sender: Any) {
        let vc = ViewController()
        let api = APIController()
        var responseJson = vc.responseJson
        
        if domainText.text == nil || mailText.text == nil || passText == nil{
            print("入力エラー")
            return
        }
        
        
        print("Debug")
        responseJson = api.regist(domain: domainText.text!, responseJson: responseJson)!
        if responseJson["client_id"] != nil {
            responseJson = api.loginAuth(domain: domainText.text!, mail: mailText.text!, pass: passText.text!, responseJson: responseJson)!
        } else {
            print("not response")
        }
        if responseJson["access_token"] != nil {
            responseJson = api.toot(domain: domainText.text!, content: contentText.text!, responseJson: responseJson)!
        }
    }
    
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
