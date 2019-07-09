//
//  CartProductCell.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 01/02/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit

class CartProductCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblLockType: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblSeriesName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
