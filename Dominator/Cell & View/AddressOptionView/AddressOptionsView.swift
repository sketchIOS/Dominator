//
//  AddressOptionsView.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 25/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit

@objc protocol AddressOptionsDelegate: class {
    @objc optional func selectedAddressForDelete(_ value: Int)
    @objc optional func selectedAddressForEdit(_ value: Int)
}

class AddressOptionsView: UIView {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    weak var delegate: AddressOptionsDelegate?

    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func initialSetUp() {
        self.btnEdit.tag = self.tag
        self.btnDelete.tag = self.tag
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func deleteAction(_ sender: Any) {
        self.removeFromSuperview()

        delegate?.selectedAddressForDelete!(self.tag)
    }
    @IBAction func editAddressAction(_ sender: Any) {
        self.removeFromSuperview()

        delegate?.selectedAddressForEdit!(self.tag)
    }
    @IBAction func closeMe(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
