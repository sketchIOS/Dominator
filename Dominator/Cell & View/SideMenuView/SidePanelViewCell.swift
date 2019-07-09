//
//  SidePanelViewCell.swift
//  Yallautlob
//
//  Created by IOS DEVELOPER on 17/01/18.
//  Copyright © 2018 IOS DEVELOPER. All rights reserved.
//

import UIKit

class SidePanelViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    //@IBOutlet weak var imageViewMenuIcon: UIImageView!
    @IBOutlet weak var lblLine: UILabel!
   // @IBOutlet weak var imageViewArrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
