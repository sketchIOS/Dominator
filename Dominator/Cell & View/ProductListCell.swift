//
//  ProductListCell.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 08/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit

class ProductListCell: UITableViewCell {

    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgvProduct: UIImageView!
    @IBOutlet weak var btnViewFull: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
