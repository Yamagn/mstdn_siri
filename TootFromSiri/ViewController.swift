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
    
    var api = APIController()
    
    // Mastodonのインスタンスから返ってくるjson格納用
    var responseJson = Dictionary<String, AnyObject>()
    
//    let session = URLSession.shared

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
        do{
            responseJson = api.regist(domain: domainText.text!, responseJson: responseJson)!
            responseJson = api.loginAuth(domain: domainText.text!, mail: mailText.text!, pass: passText.text!, responseJson: responseJson)!
            Indicator.stopAnimating()
            let alert = UIAlertController(title: "成功", message: "ログインに成功しました", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
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
    
    func donateInteraction() {
        let intent = LetstootIntent()

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

