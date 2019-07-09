//
//  AddressCell.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 11/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
