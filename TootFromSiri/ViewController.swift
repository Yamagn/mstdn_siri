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
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    @IBOutlet weak var domainText: UITextField!
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if domainText.text == nil{
            let alert = UIAlertController(title: "入力エラー", message: "ドメインが正しく入力されていません", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                return
            });
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        regist()
    }
    
    @IBAction func TootButton(_ sender: Any) {
        Indicator.startAnimating()
        let tootUrl = URL(string: "https://mstdn.maud.io/api/v1/statuses")!
        
        let tootBody: [String: String] = ["access_token": responseJson["access_token"] as! String, "status": self.TootContent.text!, "visibility": "public"]
        
        do {
            try post(url: tootUrl, body: tootBody) {data, response, error in
                
            }
            Indicator.stopAnimating()
            
            let alert = UIAlertController(title: "成功！", message: "トゥートしました", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
            });
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        } catch {
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let login = segue.destination as? loginViewController
        let _ = login?.view
        login?.resJson = self.responseJson
    }
    
    func regist(){
        let registUrl = URL(string: "https://" + domainText.text! + "/api/v1/apps")!
        
        let registBody: [String: String] = ["client_name": "TootFromSiri", "redirect_uris": "urn:ietf:wg:oauth:2.0:oob", "scopes": "write"]
        
        do {
            try post(url: registUrl, body: registBody) { data, response, error in
                do {
                    self.responseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                } catch{
                    return
                }
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        } catch {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.Indicator.hidesWhenStopped = true
    }
}

