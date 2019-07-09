//
//  SendQuoteViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 10/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SendQuoteViewController: UIViewController,UITextFieldDelegate,DropDownDelegate {

    @IBOutlet weak var cntrlAttach: UIControl!
    @IBOutlet weak var imgvAttach: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var txtTotalprice: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblProductInfo: UILabel!
    @IBOutlet weak var imgvProduct: UIImageView!
    @IBOutlet weak var lblLocktype: UILabel!
    @IBOutlet weak var txtInstallationprice: UITextField!
    var isAttach = false
    var isLockTypeOpened = false
    var selectedTypePrice = "0.00"
    
    var productDetails = ProductObject()
    let customIndicator = Indicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        cntrlAttach.layer.borderWidth = 2.0
        cntrlAttach.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        loadProductDetails()
        priceForLockTypeServiceApi(lockType: "Digital Lock")

    }
    func loadProductDetails() {
        self.lblLocktype.text = "Digital Lock"
        self.txtInstallationprice.text = "0.00"
        self.txtTotalprice.text = self.productDetails.pPrice
        self.lblProductName.text = self.productDetails.pName
        self.imgvProduct.sd_setShowActivityIndicatorView(true)
        if self.productDetails.pArrImages.count > 0 {
            let imgDic = self.productDetails.pArrImages[0]
            let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
            self.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
        }
        if self.productDetails.pDescription.count > 0 {
            let htmlData = NSString(string: self.productDetails.pDescription).data(using: String.Encoding.unicode.rawValue)
            self.lblProductInfo.attributedText = try! NSAttributedString(data: htmlData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            self.lblProductInfo.textColor = UIColor.white
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @IBAction func openDropdownForLockType(_ sender: Any) {
        //Key Lock, Combination Lock and Digital Lock
        self.view.endEditing(true)
        if isLockTypeOpened {
            return
        }
        isLockTypeOpened = true
        var dropDownView = DropdownView()
        dropDownView = .fromNib()
        dropDownView.frame = CGRect(x: 155, y: 250, width: 150, height: 105)
        dropDownView.initialSetupWithData(arrayData: ["Key Lock","Combination Lock","Digital Lock"])
        dropDownView.delegate = self
        self.view.addSubview(dropDownView)
        
    }
    @IBAction func attachBrochureClicked(_ sender: Any) {
        isAttach = !isAttach
        if isAttach {
            self.imgvAttach.image = UIImage(named:"black-tick")
        }else{
            self.imgvAttach.image = UIImage(named:"black-without-tick")
        }
    }
    
    @IBAction func sendQuoteAction(_ sender: Any) {
       // self.navigationController?.popViewController(animated: false)
        if (self.txtInstallationprice.text?.isEmpty)! {
            toastView(messsage: "Please give installation price", view: self.view)
        }else if !((self.txtInstallationprice.text?.isNumeric)!) {
            toastView(messsage: "Please give installation price in numeric", view: self.view)
        }else if (self.txtTotalprice.text?.isEmpty)! {
            toastView(messsage: "Please give total price", view: self.view)
        }else if !((self.txtTotalprice.text?.isNumeric)!) {
            toastView(messsage: "Please give total price in numeric", view: self.view)
        }else if (self.txtEmail.text?.isEmpty)! {
            toastView(messsage: "Please give email id", view: self.view)
        }else if !isValidEmail(email: self.txtEmail.text) {
            toastView(messsage: "Please give valid email id", view: self.view)
        }else{
            submitQuoteServiceApi()
        }
    }
    func selectedDataFromDropDown(_ value: String?) {
        isLockTypeOpened = false
        priceForLockTypeServiceApi(lockType: value!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "0.00" {
           textField.text = ""
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtInstallationprice {
            if textField.text == "" {
                textField.text = "0.00"
            }
            if (self.txtInstallationprice.text?.isNumeric)! {
                guard let num1 = Double(self.txtInstallationprice.text!),
                    let num2 = Double(self.selectedTypePrice)
                    else {
                        return
                }
                let total = num1 + num2
                self.txtTotalprice.text = String(format: "%.2f", total)
            }
        }
    }
    //MARK: - API call
    func priceForLockTypeServiceApi(lockType: String){
        var paramDict: Dictionary = [String: String]()
        paramDict["product_id"] = self.productDetails.pId
        paramDict["lock_type"] = lockType
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.productPriceLockType, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    // print(dicJson)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            if let price = responseValue["data"] as? String {
                                self.lblLocktype.text = lockType
                                self.selectedTypePrice = price
                                guard let num1 = Double(self.txtInstallationprice.text!),
                                    let num2 = Double(price)
                                    else {
                                        return
                                }
                                let total = num1 + num2
                                self.txtTotalprice.text = String(format: "%.2f", total)
                            }
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                }
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    func submitQuoteServiceApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["user_id"] = USERDEFAULTS.value(forKey: "uId") as? String
        paramDict["product_id"] = self.productDetails.pId
        paramDict["installation_price"] = self.txtInstallationprice.text
        paramDict["total_price"] = self.txtTotalprice.text
        paramDict["customer_email"] = self.txtEmail.text
        paramDict["lock_type"] = self.lblLocktype.text
        paramDict["attachBrochure"] = isAttach ? "1" : "0"

        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.insertQuote, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    // print(dicJson)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                            self.perform(#selector(self.backToProduct), with: nil, afterDelay: 3.0)
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                }
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    @objc func backToProduct() {
        self.navigationController?.popViewController(animated: false)
    }
}
