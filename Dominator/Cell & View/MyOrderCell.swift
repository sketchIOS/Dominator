//
//  MyOrderCell.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 10/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var lblOrderStatus: UIImageView!
    @IBOutlet weak var lblProductInfo: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
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
