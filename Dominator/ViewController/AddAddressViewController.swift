//
//  AddAddressViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 23/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddAddressViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    let customIndicator = Indicator()
    var isEditMode = false
    var addressDetails : AddressObject = AddressObject()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isEditMode {
            self.txtName.text = addressDetails.aShipName
            self.txtMobile.text = addressDetails.aPhoneNo
            self.txtAddress.text = addressDetails.aAddress
         //   self.txtCountry.text = addressDetails.aCountry
            self.txtState.text = addressDetails.aState
            self.txtCity.text = addressDetails.aCity
            self.txtZip.text = addressDetails.aZip
        }else{
            self.txtName.text = USERDEFAULTS.value(forKey: "userName") as? String
            self.txtMobile.text = USERDEFAULTS.value(forKey: "userPhone") as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func saveAddressAction(_ sender: Any) {
        if (txtName.text?.isEmpty)! {
            toastView(messsage: "Give Name", view: self.view)
        }else if (txtMobile.text?.isEmpty)! {
            toastView(messsage: "Give Phone number", view: self.view)
        }else if (txtAddress.text?.isEmpty)! {
            toastView(messsage: "Give Address", view: self.view)
        }else if (txtCity.text?.isEmpty)! {
            toastView(messsage: "Give Suburb", view: self.view)
        }else if (txtState.text?.isEmpty)! {
            toastView(messsage: "Give State", view: self.view)
        }else if (txtZip.text?.isEmpty)! {
            toastView(messsage: "Give Postcode", view: self.view)
        }else{
            if isEditMode {
                editAddressServiceCall()
            }else{
                addAddressServiceCall()
            }
        }
    }
    //MARK: - API call for login
    func addAddressServiceCall(){
        var dataDict: Dictionary = [String: String]()
        dataDict["userid"] = USERDEFAULTS.value(forKey: "uId") as? String
        dataDict["name"] = txtName.text
       // dataDict["country"] = txtCountry.text
        dataDict["state"] = txtState.text
        dataDict["zip"] = txtZip.text
        dataDict["mobile"] = txtMobile.text
        dataDict["address"] = txtAddress.text
        dataDict["city"] = txtCity.text

        print(dataDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.addAddress, method: .post, parameters:dataDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    let dicJson = responseValue as NSDictionary
                    // print(dicJson)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                            self.perform(#selector(self.backToMyAddress), with: nil, afterDelay: 1.0)
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                    self.customIndicator.stopAnimating()
                    self.customIndicator.removeFromSuperview()
                }
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    func editAddressServiceCall(){
        var dataDict: Dictionary = [String: String]()
        dataDict["userid"] = USERDEFAULTS.value(forKey: "uId") as? String
        dataDict["name"] = txtName.text
      //  dataDict["country"] = txtCountry.text
        dataDict["state"] = txtState.text
        dataDict["zip"] = txtZip.text
        dataDict["mobile"] = txtMobile.text
        dataDict["address"] = txtAddress.text
        dataDict["city"] = txtCity.text
        dataDict["shipping_id"] = addressDetails.aId

        print(dataDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.editAddress, method: .post, parameters:dataDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    let dicJson = responseValue as NSDictionary
                    // print(dicJson)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                            self.perform(#selector(self.backToMyAddress), with: nil, afterDelay: 1.0)
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                    self.customIndicator.stopAnimating()
                    self.customIndicator.removeFromSuperview()
                }
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    @objc func backToMyAddress() {
        self.navigationController?.popViewController(animated: false)
    }
}
