//
//  ReturnViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 23/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ReturnViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var cntrlAttach: UIControl!
    @IBOutlet weak var imgvAttach: UIImageView!
    @IBOutlet weak var imgvReturn: UIImageView!
    @IBOutlet weak var txtvReason: UITextView!
    @IBOutlet weak var imgvProduct: UIImageView!
    @IBOutlet weak var lblProductInfo: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    var isAttach = false
    var orderDetails = OrderObject()
    var picker:UIImagePickerController?=UIImagePickerController()
    let customIndicator = Indicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgvReturn.isHidden = true
        self.addToolBar(textView: self.txtvReason)
        loadOrderDetails()
        // Do any additional setup after loading the view.
    }
    func loadOrderDetails() {
        self.lblProductName.text = self.orderDetails.addedProducts[0].pName
        self.imgvProduct.sd_setShowActivityIndicatorView(true)
        if self.orderDetails.addedProducts[0].pArrImages.count > 0 {
            let imgDic = self.orderDetails.addedProducts[0].pArrImages[0]
            let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
            self.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
        }
        if self.orderDetails.addedProducts[0].pDescription.count > 0 {
            let htmlData = NSString(string: self.orderDetails.addedProducts[0].pDescription).data(using: String.Encoding.unicode.rawValue)
            self.lblProductInfo.attributedText = try! NSAttributedString(data: htmlData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            self.lblProductInfo.textColor = UIColor.white
        }
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func submitReturnProductAction(_ sender: Any) {
        if (self.txtvReason.text?.isEmpty)! {
            toastView(messsage: "Please give your reason", view: self.view)
        }else{
            returnProductServiceCall()
        }
    }
    @IBAction func attachImageAction(_ sender: Any) {
        isAttach = !isAttach
        if isAttach {
            self.imgvAttach.image = UIImage(named:"black-tick")
            self.imgvReturn.isHidden = false
            //self.imgvReturn.image = nil
            openActionSheetForCamera()
        }else{
            self.imgvAttach.image = UIImage(named:"black-without-tick")
            self.imgvReturn.isHidden = true
        }
    }
    func openActionSheetForCamera() {
        
        let alertController = UIAlertController(title: title, message: "Select Image", preferredStyle: UIAlertControllerStyle.actionSheet)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
            self.isAttach = false
            self.imgvReturn.isHidden = true
            self.imgvAttach.image = UIImage(named:"black-without-tick")

        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Camera")
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Gallery")
            self.openGallary()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    func openGallary()
    {
        picker!.allowsEditing = false
        picker?.delegate = self
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker?.delegate = self
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isAttach = false
        self.imgvReturn.isHidden = true
        self.imgvAttach.image = UIImage(named:"black-without-tick")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imgvReturn.image = image
        self.imgvReturn.isHidden = false
        isAttach = true
        dismiss(animated: true, completion: nil)
    }
    func addToolBar(textView: UITextView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed(button:)))
        doneButton.tag = textView.tag
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        // let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        toolBar.setItems([doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        //textView.delegate = self
        textView.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(button: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    // MARK:- update profile service call
    
    func returnProductServiceCall(){
        
        
        var profileDict: Dictionary = [String: String]()
        
        profileDict["orderid"] = orderDetails.oId
        profileDict["reason"] = txtvReason.text
        
        print(profileDict)
        
        let imageData = UIImageJPEGRepresentation(self.imgvReturn.image!, 0.5)
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in profileDict {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "noname.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: APPURL.returnProduct, method: .post) { (result) in
            switch result{
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    print(response)
                    if let JSON = response.result.value as? [String: Any] {
                        
                        self.customIndicator.stopAnimating()
                        self.customIndicator.removeFromSuperview()
                        
                        let message = JSON["message"] as? String
                        //                        let orderID = JSON["order_id"] as? Int
                        print(message ?? "default-msg")
                        //                        print(orderID ?? "default-ordID")
                        print(JSON)
                        toastView(messsage: message!, view: self.view)
                        self.perform(#selector(self.backToMyOrder), with: nil, afterDelay: 1.0)
                    }
                    
                }
                
                
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                // onError?(error)
            }
        }
        
    }
    @objc func backToMyOrder() {
        // back to category page
        let arrV = self.navigationController?.viewControllers
        for vc in arrV! {
            if vc.isKind(of: MyOrderViewController.self){
                let catVC = vc as! MyOrderViewController
                self.navigationController?.popToViewController(catVC, animated: false)
                break
            }
        }
    }
}
