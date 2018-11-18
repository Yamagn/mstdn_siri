//
//  SettingViewController.swift
//  TootFromSiri
//
//  Created by ymgn on 2018/11/15.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import IntentsUI
import Intents
import os.log

class SettingViewController: UIViewController{
    @IBOutlet weak var contentText: UITextField!
    @IBOutlet var settingView: UIView!
    
    private var intent = LetstootIntent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func configureView() {
        let addShortcutButton = INUIAddVoiceShortcutButton(style: .black)
        addShortcutButton.shortcut = INShortcut(intent: intent)
        addShortcutButton.delegate = self
        
        addShortcutButton.translatesAutoresizingMaskIntoConstraints = false
        settingView.addSubview(addShortcutButton)
        settingView.centerXAnchor.constraint(equalTo: addShortcutButton.centerXAnchor).isActive = true
        settingView.centerYAnchor.constraint(equalTo: addShortcutButton.centerYAnchor).isActive = true
    }
    
    @IBAction func settingClicked(_ sender: Any) {
        if let content = contentText.text {
            intent.content = content
            configureView()
        } else {
            let controller = UIAlertController(title: nil, message: "内容を入力してください", preferredStyle: UIAlertController.Style.alert)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
    }
}

extension SettingViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutButton.delegate = self
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
}

extension SettingViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
