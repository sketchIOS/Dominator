//
//  OrderDetailsProductCell.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 01/02/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit

class OrderDetailsProductCell: UITableViewCell {

    @IBOutlet weak var lblLockType: UILabel!
    @IBOutlet weak var lblAmaunt: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgvProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
