//
//  TootCell.swift
//  TootTestUI
//
//  Created by ymgn on 2018/11/18.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class TootCell: UITableViewCell {
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tootContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
