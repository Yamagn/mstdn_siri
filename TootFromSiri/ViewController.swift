//
//  ViewController.swift
//  TootFromSiri
//
//  Created by ymgn on 2018/09/22.
//  Copyright © 2018年 ymgn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Mastodonのインスタンスから返ってくるjson格納用
    var responseJson = Dictionary<String, AnyObject>()
    
    let session = URLSession.shared
    
    // POST メソッド
    func post(url: URL, body: Dictionary<String, String>, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }

    @IBOutlet weak var TootContent: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        let registUrl = URL(string: "https://mstdn.maud.io/api/v1/apps")!
        
        let registBody: [String: String] = ["client_name": "TootFromSiri", "redirect_uris": "urn:ietf:wg:oauth:2.0:oob", "scopes": "write"]
        
        do {
            try post(url: registUrl, body: registBody) { data, response, error in
                do {
                    self.responseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                } catch{
                    return;
                }
            }
        } catch {
            return;
        }
        
        let loginUrl = URL(string: "https://mstdn.maud.io/oauth/token")!
        
        let loginBody: [String: String] = ["scope": "write", "client_id": responseJson["client_id"] as! String, "client_secret": responseJson["client_secret"] as! String, "grant_type": "password", "username": "syankenpon@gmail.com", "password": "Tonarino10106"]
        
        do {
            try post(url: loginUrl, body: loginBody) {data, response, error in
                do {
                    self.responseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                } catch {
                }
            }
        } catch {
        }
    }
    
    @IBAction func TootButton(_ sender: Any) {
        let tootUrl = URL(string: "https://mstdn.maud.io/api/v1/statuses")!
        
        let tootBody: [String: String] = ["access_token": responseJson["access_token"] as! String, "status": self.TootContent.text!, "visibility": "public"]
        
        do {
            try post(url: tootUrl, body: tootBody) {data, response, error in
                
            }
        } catch {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

