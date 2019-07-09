//
//  QuoteDetailsViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 09/04/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SDWebImage

class QuoteDetailsViewController: UIViewController {

    @IBOutlet weak var lblInstallationPrice: UILabel!
    @IBOutlet weak var lblQuoteSentTo: UILabel!
    @IBOutlet weak var lblQuoteDate: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgvProduct: UIImageView!
    var quoteDetails = QuoteObject()

    override func viewDidLoad() {
        super.viewDidLoad()
       loadQuoteDetails()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadQuoteDetails() {
        self.lblProductName.text = self.quoteDetails.qProductName
        self.imgvProduct.sd_setShowActivityIndicatorView(true)
        if self.quoteDetails.qArrImages.count > 0 {
            let imgDic = self.quoteDetails.qArrImages[0]
            let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
            self.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
        }
        self.lblType.text = "Lock type : " + self.quoteDetails.qLockType
        self.lblTotalPrice.text = "Total price : " + self.quoteDetails.qTotalPrice
        self.lblInstallationPrice.text = "Installation price : " + self.quoteDetails.qInstallationPrice
        self.lblQuoteDate.text = "Quote date : " + self.quoteDetails.qDate
        self.lblQuoteSentTo.text = "Quote sent to : " + self.quoteDetails.qEmail
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func callDominatorAxction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
