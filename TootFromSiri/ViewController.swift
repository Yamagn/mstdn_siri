//
//  ViewController.swift
//  TootFromSiri
//
//  Created by ymgn on 2018/09/22.
//  Copyright © 2018年 ymgn. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {
    
    // Mastodonのインスタンスから返ってくるjson格納用
    var responseJson = Dictionary<String, AnyObject>()
    
    class HttpClientImpl {
        private let session: URLSession
        public  init(config: URLSessionConfiguration? = nil) {
            self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
        }
        
        public func execute(request: URLRequest) -> (NSData?, URLResponse?, NSError?) {
            var d: NSData? = nil
            var r: URLResponse? = nil
            var e: NSError? = nil
            let semaphore = DispatchSemaphore(value: 0)
            session.dataTask(with: request) { (data, response, error) -> Void in
                d = data as NSData?
                r = response
                e = error as NSError?
                semaphore.signal()
            }.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            return(d, r, e)
        }
    }
    
//    let session = URLSession.shared
    
    // POST メソッド
    func post(url: URL, body: Dictionary<String, String>, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        let session = HttpClientImpl()
        session.execute(request: request as URLRequest)
    }

    @IBOutlet weak var TootContent: UITextField!
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    @IBOutlet weak var domainText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        if domainText.text == nil || mailText.text == nil || passText == nil{
            let alert = UIAlertController(title: "入力エラー", message: "正しく入力されていません", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                return
            });
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
        self.regist(domain: domainText.text!)
        self.loginAuth(domain: domainText.text!, mail: mailText.text!, pass: passText.text!)
    }
    
    @IBAction func TootButton(_ sender: Any) {
        Indicator.startAnimating()
        let tootUrl = URL(string: "https://" + domainText.text! + "/api/v1/statuses")!
        
        let tootBody: [String: String] = ["access_token": responseJson["access_token"] as! String, "status": self.TootContent.text!, "visibility": "public"]
        do {
            var request: URLRequest = URLRequest(url: tootUrl)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: tootBody, options: .prettyPrinted)
            
            let session = HttpClientImpl()
            let (data, _, _) = session.execute(request: request as URLRequest)
            self.responseJson = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
            
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
    
    func regist(domain: String){
        let registUrl = URL(string: "https://" + domain + "/api/v1/apps")!
        
        let registBody: [String: String] = ["client_name": "TootFromSiri", "redirect_uris": "urn:ietf:wg:oauth:2.0:oob", "scopes": "write"]
        
        do {
            var request: URLRequest = URLRequest(url: registUrl)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: registBody, options: .prettyPrinted)
            
            let session = HttpClientImpl()
            var (data, _, _) = session.execute(request: request as URLRequest)
            self.responseJson = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
        } catch {
            let alert = UIAlertController(title: "失敗", message: "ログインに失敗しました", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(defaultAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func loginAuth(domain: String, mail: String, pass: String){
        let loginUrl = URL(string: "https://" + domain + "/oauth/token")!
        if responseJson["client_id"] == nil{
            return
        }
        
        let loginBody: [String: String] = ["scope": "write", "client_id": responseJson["client_id"] as! String, "client_secret": responseJson["client_secret"] as! String, "grant_type": "password", "username": mail, "password": pass]
        
        do {
            var request: URLRequest = URLRequest(url: loginUrl)
        
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: loginBody, options: .prettyPrinted)
            
            let session = HttpClientImpl()
            var (data, _, _) = session.execute(request: request as URLRequest)
            self.responseJson = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
            let alert = UIAlertController(title: "成功", message: "ログインに成功しました", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        } catch {
            return
        }
    }
    
    func donateInteraction() {
        let intent = TootIntent()
        
        intent.suggestedInvocationPhrase = "トゥート"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate{ (error) in
            if error != nil {
                if error != nil {
                    print("Error")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.Indicator.hidesWhenStopped = true
        donateInteraction()
    }
}

