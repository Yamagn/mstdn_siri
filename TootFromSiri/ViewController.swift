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

var realm = try! Realm()
var user: User = User()
public class Info {
    static var access_token = user.access_token
    static var domain = user.domain
}

class User: Object {
    @objc dynamic var domain: String = ""
    @objc dynamic var mail: String = ""
    @objc dynamic var pass: String = ""
    @objc dynamic var access_token: String = ""
}

class ViewController: UIViewController {
    
    // Mastodonのインスタンスから返ってくるjson格納用
    var responseJson = Dictionary<String, AnyObject>()
    
//    let session = URLSession.shared

    @IBOutlet weak var TootContent: UITextField!
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    @IBOutlet weak var domainText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var button: UIButton!
    
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
            try! realm.write {
                realm.deleteAll()
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
        responseJson = api.regist(domain: domainText.text!, responseJson: responseJson)!
        responseJson = api.loginAuth(domain: domainText.text!, mail: mailText.text!, pass: passText.text!, responseJson: responseJson)!
        Indicator.stopAnimating()
        let user = User()
        user.domain = self.domainText.text!
        user.mail = self.mailText.text!
        user.pass = self.passText.text!
        user.access_token = self.responseJson["access_token"] as! String
        try! realm.write {
            realm.add(user)
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
    }
    
    @IBAction func TootButton(_ sender: Any) {
        Indicator.startAnimating()
        responseJson = api.tootWithToken(domain: user.domain, content: TootContent.text!, access_token: user.access_token)!
        Indicator.stopAnimating()
        let alert = UIAlertController(title: "成功！", message: "トゥートしました", preferredStyle: UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            self.TootContent.text = nil
        });
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func siriSettingButton(_ sender: Any) {
        performSegue(withIdentifier: "siriSetting", sender: nil)
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
            user = users[0]
            print(Info.access_token)
            print(Info.domain)
        }
        self.Indicator.hidesWhenStopped = true
    }
}

