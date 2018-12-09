//
//  ViewController.swift
//  TootFromSiri
//
//  Created by ymgn on 2018/09/22.
//  Copyright © 2018年 ymgn. All rights reserved.
//

import UIKit
import Intents
import RealmSwift

class User: Object {
    @objc dynamic var domain: String = ""
    @objc dynamic var mail: String = ""
    @objc dynamic var pass: String = ""
    @objc dynamic var access_token: String = ""
}

class ViewController: UIViewController {
    
    var api = APIController()
    var realm = try! Realm()
    
    // Mastodonのインスタンスから返ってくるjson格納用
    var responseJson = Dictionary<String, AnyObject>()
    
//    let session = URLSession.shared

    @IBOutlet weak var TootContent: UITextField!
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    @IBOutlet weak var domainText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var button: UIButton!
    var user: User = User()
    
    var tootContent: String? = nil;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if button.currentTitle == "ログアウト" {
            try! self.realm.write {
                self.realm.deleteAll()
            }
            domainText.isHidden = false
            mailText.isHidden = false
            passText.isHidden = false
            button.setTitle("ログイン", for: .normal)
            let alert = UIAlertController(title: "成功", message: "ログアウトしました", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                return
            });
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        if domainText.text == nil || mailText.text == nil || passText == nil{
            let alert = UIAlertController(title: "入力エラー", message: "正しく入力されていません", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                return
            });
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
        do{
            responseJson = api.regist(domain: domainText.text!, responseJson: responseJson)!
            responseJson = api.loginAuth(domain: domainText.text!, mail: mailText.text!, pass: passText.text!, responseJson: responseJson)!
            Indicator.stopAnimating()
            let user = User()
            user.domain = self.domainText.text!
            user.mail = self.mailText.text!
            user.pass = self.passText.text!
            user.access_token = self.responseJson["access_token"] as! String
            try! self.realm.write {
                self.realm.add(user)
            }
            self.domainText.isHidden = true
            self.mailText.isHidden = true
            self.passText.isHidden = true
            self.button.setTitle("ログアウト", for: .normal)
            let alert = UIAlertController(title: "成功", message: "ログインに成功しました", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                return
            })
            
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "失敗", message: "ログインに失敗しました", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(defaultAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func TootButton(_ sender: Any) {
        Indicator.startAnimating()
        responseJson = api.toot(domain: domainText.text!, content: TootContent.text!, responseJson: responseJson)!
        Indicator.stopAnimating()
        let alert = UIAlertController(title: "成功！", message: "トゥートしました", preferredStyle: UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        });
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func siriSettingButton(_ sender: Any) {
        performSegue(withIdentifier: "siriSetting", sender: nil)
    }
    
    func donateInteraction() {
        let intent = TimelineIntent()
        intent.suggestedInvocationPhrase = "タイムラインを取得"
        intent.access_token = self.user.access_token
        intent.domain = self.user.domain

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
        let users = realm.objects(User.self)
        if users.count != 0 {
            domainText.isHidden = true
            mailText.isHidden = true
            passText.isHidden = true
            button.setTitle("ログアウト", for: .normal)
            self.user = users[0]
        }
        self.Indicator.hidesWhenStopped = true
        donateInteraction()
    }
}

