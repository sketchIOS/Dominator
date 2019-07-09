//
//  ChangePasswordViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 11/04/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {

    let customIndicator = Indicator()

    @IBOutlet weak var txtReNewPassword: UITextField!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @IBAction func updatePasswordAction(_ sender: Any) {
        if (self.txtCurrentPassword.text?.isEmpty)! {
            toastView(messsage: "Please give current password", view: self.view)
        }else if (self.txtNewPassword.text?.isEmpty)! {
            toastView(messsage: "Please give new password", view: self.view)
        }else if (self.txtReNewPassword.text?.isEmpty)! {
            toastView(messsage: "Please re-enter new password", view: self.view)
        }
        else if self.txtReNewPassword.text != self.txtNewPassword.text {
            toastView(messsage: "Please give new password & re-enter new password same", view: self.view)
        }
        else{
            changePasswordServiceCall()
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func changePasswordServiceCall(){
        var loginDict: Dictionary = [String: String]()
        if let userId = USERDEFAULTS.value(forKey: "uId") as? String{
            loginDict["user_id"] = userId
        }
        loginDict["old_password"] = txtCurrentPassword.text
        loginDict["new_password"] = txtNewPassword.text
        
        print(loginDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.changePassword, method: .post, parameters:loginDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            self.perform(#selector(self.backToLogin), with: nil, afterDelay: 3.0)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func backToLogin() {
        USERDEFAULTS.set(false, forKey: "isLoggedIn")
        let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.launchSignInController()
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
