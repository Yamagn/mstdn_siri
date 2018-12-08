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
    @IBOutlet var tableView: UITableView!
    var dataList:[Toots] = []
    var responseJson = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TootCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "TootCell")
        reloadListDatas()
    }

    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        guard interaction.intent is TimelineIntent else {
            completion(false, Set(), .zero)
            return
        }
        
        completion(true, parameters, self.desiredSize)
    }

    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TootCell = tableView.dequeueReusableCell(withIdentifier: "TootCell", for: indexPath) as! TootCell

        let data = dataList[indexPath.row]
//        let attributedString = NSAttributedString.parseHTML2Text(sourceText: data.content)
//        cell.tootContent.attributedText = attributedString
        cell.tootContent.text = data.content
        cell.userID.text = "@" + data.account.username
        cell.userName.text = data.account.display_name
        cell.userImage.setImage(fromUrl: data.account.avatar)
        return cell
    }

    func reloadListDatas() {
        let domain = "mstdn.maud.io"
        let mail = "syankenpon@gmail.com"
        let pass = "Tonarino10106"
        let api = APIController()

        responseJson = api.regist(domain: domain, responseJson: responseJson)!
        responseJson = api.loginAuth(domain: domain, mail: mail, pass: pass, responseJson: responseJson)!
        dataList = api.getTl(domain: domain, responseJson: responseJson)
        self.tableView.reloadData()
    }
}

extension UIImageView {
    public func setImage(fromUrl url: URL) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data, let _ = response, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
