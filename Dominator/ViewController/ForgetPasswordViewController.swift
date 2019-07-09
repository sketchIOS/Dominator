//
//  ForgetPasswordViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 14/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordViewController: UIViewController,UITextFieldDelegate {
    let customIndicator = Indicator()
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendAction(_ sender: Any) {
        if (self.txtEmail.text?.isEmpty)! {
            toastView(messsage: "Please give email id", view: self.view)
        }else if !isValidEmail(email: self.txtEmail.text) {
            toastView(messsage: "Please give valid email id", view: self.view)
        }
        else{
            forgetPasswordServiceCall()
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
    func forgetPasswordServiceCall(){
        var loginDict: Dictionary = [String: String]()
        loginDict["email"] = txtEmail.text
        
        print(loginDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.forgotPasswordUrl, method: .post, parameters:loginDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            
                                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                                let vController = mainStoryBoard.instantiateViewController(withIdentifier: "ResetViewController") as! ResetViewController
                                vController.forgetPassEmail = self.txtEmail.text!
                                self.navigationController?.pushViewController(vController, animated: false)
                            
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

}
