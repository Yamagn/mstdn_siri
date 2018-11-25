//
//  TootCell.swift
//  TootTestUI
//
//  Created by ymgn on 2018/11/18.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class TootCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
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

extension UIImageView {
    public func setImage(fromUrl: URL) {
        URLSession.shared.dataTask(with: fromUrl) { (data, _, _) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
