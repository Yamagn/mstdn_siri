//
//  ParseHTML.swift
//  TootFromSiri
//
//  Created by ymgn on 2018/12/01.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func parseHTML2Text(sourceText text: String) -> NSAttributedString? {
        let encodeData = text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let attributedOptions = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html as AnyObject,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue as AnyObject
        ]
        
        var attributedString: NSAttributedString?
        if let encodeData = encodeData {
            do {
                attributedString = try NSAttributedString(data: encodeData, options: attributedOptions, documentAttributes: nil)
            } catch _ {
                
            }
        }
        return attributedString
    }
}
