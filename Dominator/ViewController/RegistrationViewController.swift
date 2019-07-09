//
//  RegistrationViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 07/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistrationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    let customIndicator = Indicator()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func registerAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if (txtUserName.text?.isEmpty)! {
            toastView(messsage: "Give User Name", view: self.view)
        }else if !((txtEmailId.text?.isValid(regex: .email))!) {
            toastView(messsage: "Give Right Email Id", view: self.view)
        }else if (txtPhoneNumber.text?.isEmpty)! {
            toastView(messsage: "Give Phone Number", view: self.view)
        }else if !((txtPhoneNumber.text?.isValid(regex: .phone))!) {
            toastView(messsage: "Give Valid Phone Number", view: self.view)
        }else if (txtPassword.text?.isEmpty)! {
            toastView(messsage: "Give Password", view: self.view)
        }else if (txtConfirmPassword.text?.isEmpty)! {
            toastView(messsage: "Give Confirm Password", view: self.view)
        }
        else{
            registrationServiceCall()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: - API call for login
    func registrationServiceCall(){
        var loginDict: Dictionary = [String: String]()
        loginDict["username"] = txtUserName.text
        loginDict["email_id"] = txtEmailId.text
        loginDict["phone"] = txtPhoneNumber.text
        loginDict["password"] = txtPassword.text
        loginDict["device_type"] = "ios"
        loginDict["device_id"] = "12345787"
        loginDict["fcm_token"] = ""
        
        print(loginDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.registrationUrl, method: .post, parameters:loginDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    let dicJson = responseValue as NSDictionary
                    // print(dicJson)
                    
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            
                            if let dictUserDetails = responseValue ["data"] as? NSDictionary {
                                // print(dictUserDetails)
                                if let userId = dictUserDetails ["id"] as? String{
                                    USERDEFAULTS.set(userId, forKey: "uId")
                                }
                                if let email = dictUserDetails ["email"] as? String{
                                    USERDEFAULTS.set(email, forKey: "userEmail")
                                }
                                if let name = dictUserDetails ["username"] as? String{
                                    USERDEFAULTS.set(name, forKey: "userName")
                                }
                                if let mobile = dictUserDetails ["phone"] as? String{
                                    USERDEFAULTS.set(mobile, forKey: "userPhone")
                                }
                              //  USERDEFAULTS.set(self.txtPassword.text, forKey: "userPass")
                               // USERDEFAULTS.set(true, forKey: "isLoggedIn")
                                self.customIndicator.stopAnimating()
                                self.customIndicator.removeFromSuperview()
                                
                                self.navigationController?.popViewController(animated: false)
                            }
                            
                        }else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                        self.customIndicator.stopAnimating()
                        self.customIndicator.removeFromSuperview()
                    }
                }
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }

}
