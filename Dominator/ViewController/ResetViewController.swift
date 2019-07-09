//
//  ResetViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 14/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResetViewController: UIViewController,UITextFieldDelegate {
    let customIndicator = Indicator()

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtOtp: UITextField!
    var forgetPassEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if (self.txtOtp.text?.isEmpty)! {
            toastView(messsage: "Please give OTP", view: self.view)
        }else if (self.txtPassword.text?.isEmpty)! {
            toastView(messsage: "Please give new password", view: self.view)
        }else if (self.txtConfirmPassword.text?.isEmpty)! {
            toastView(messsage: "Please give confirm password", view: self.view)
        }else if self.txtConfirmPassword.text != self.txtPassword.text {
            toastView(messsage: "Please give password & confirm password same", view: self.view)
        }
        else{
            resetPasswordServiceCall()
        }
    }
    @IBAction func loginAction(_ sender: Any) {
            self.navigationController?.popToRootViewController(animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: - API call for login
    func resetPasswordServiceCall(){
        var loginDict: Dictionary = [String: String]()
        loginDict["email"] = forgetPassEmail
        loginDict["otp_code"] = txtOtp.text
        loginDict["new_password"] = txtPassword.text

        print(loginDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.resetPasswordUrl, method: .post, parameters:loginDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            self.perform(#selector(self.backToLogin), with: nil, afterDelay: 1.0)
                        }else{
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
   @objc func backToLogin() {
      USERDEFAULTS.set(false, forKey: "isLoggedIn")
      let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
      appDel.launchSignInController()
    }

}
