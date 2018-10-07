//
//  loginViewController.swift
//  TootFromSiri
//
//  Created by ymgn on 2018/10/07.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    let domain : String = ""
    var resJson = Dictionary<String, AnyObject>()
    let session = URLSession.shared
    
    @IBOutlet weak var userid: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if userid.text == nil || pass.text == nil{
            let alert = UIAlertController(title: "入力エラー", message: "メールアドレスもしくはパスワードが正しく入力されていません", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
            });
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        loginAuth()
    }
    
    
    func post(url: URL, body: Dictionary<String, String>, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func loginAuth(){
        let loginUrl = URL(string: "https://" + domain + "/oauth/token")!
        
        let loginBody: [String: String] = ["scope": "write", "client_id": resJson["client_id"] as! String, "client_secret": resJson["client_secret"] as! String, "grant_type": "password", "username": userid.text!, "password": pass.text!]
        
        do {
            try post(url: loginUrl, body: loginBody) {data, response, error in
                do {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    self.resJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                } catch {
                    return
                }
                let alert = UIAlertController(title: "成功", message: "ログインに成功しました", preferredStyle: UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    self.navigationController?.popViewController(animated: true)
                });
                
                alert.addAction(defaultAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        } catch {
            return
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
