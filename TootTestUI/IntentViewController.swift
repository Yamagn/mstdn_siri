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

class IntentViewController: UIViewController, INUIHostedViewControlling, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseJson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TootCell = tableView.dequeueReusableCell(withIdentifier: "TootCell", for: indexPath) as! TootCell
    }
    
    var responseJson = Dictionary<String, AnyObject>()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "TootCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "TootCell")
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        guard interaction.intent is TimelineIntent else {
            completion(false, Set(), .zero)
            return
        }
        
        let api = APIController()
        let domain = "mstdn.maud.io"
        let mail = "syankenpon@gmail.com"
        let pass = "Tonarino10106"
        responseJson = api.regist(domain: domain, responseJson: responseJson)!
        responseJson = api.loginAuth(domain: domain, mail: mail, pass: pass, responseJson: responseJson)!
        responseJson = api.getTl(domain: domain, responseJson: responseJson)!
        
        if interaction.intentHandlingStatus == .ready {
        }
        else if interaction.intentHandlingStatus == .success {
            completion(true, parameters, self.desiredSize)
        }
    }
    
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
