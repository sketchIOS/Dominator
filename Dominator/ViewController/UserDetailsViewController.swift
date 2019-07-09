//
//  UserDetailsViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 10/04/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserDetailsViewController: UIViewController, UITextFieldDelegate {
    let customIndicator = Indicator()

    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var lineName: UILabel!
    @IBOutlet weak var linePhone: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtName: UITextField!
    var isEditMode = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateUI()
        getProfileDetailsServiceCall()
        // Do any additional setup after loading the view.
      
//        if let email = USERDEFAULTS.value(forKey: "userEmail") as? String {
//            txtEmail.text = email
//        }
//        if let name = USERDEFAULTS.value(forKey: "userName") as? String {
//            txtName.text = name
//        }
//        if let phone = USERDEFAULTS.value(forKey: "userPhone") as? String {
//            txtPhone.text = phone
//        }
    }
    func updateUI() {
        if isEditMode {
            txtName.isUserInteractionEnabled = true
            txtPhone.isUserInteractionEnabled = true
            lineName.isHidden = false
            linePhone.isHidden = false
            btnEdit.setTitle("Save", for: .normal)
            txtName.becomeFirstResponder()
        }else{
            txtName.isUserInteractionEnabled = false
            txtPhone.isUserInteractionEnabled = false
            lineName.isHidden = true
            linePhone.isHidden = true
            btnEdit.setTitle("Edit", for: .normal)
            self.view.endEditing(true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changePasswordAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(vController, animated: false)
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @IBAction func editAction(_ sender: Any) {
        isEditMode = !isEditMode
        self.updateUI()
        if !isEditMode {
            updateProfileDetailsServiceCall()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getProfileDetailsServiceCall(){
        var loginDict: Dictionary = [String: String]()
        if let userId = USERDEFAULTS.value(forKey: "uId") as? String{
            loginDict["user_id"] = userId
        }
        
        print(loginDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.userDetails, method: .post, parameters:loginDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                   // let dicJson = responseValue as NSDictionary
                    // print(dicJson)
                    
                    if let status = responseValue["status"] as? Int {
                        if status == 1{

                               if let userId = responseValue ["id"] as? String{
                                    USERDEFAULTS.set(userId, forKey: "uId")
                                }
                                if let email = responseValue ["email"] as? String{
                                    USERDEFAULTS.set(email, forKey: "userEmail")
                                    self.txtEmail.text = email
                                }
                                if let name = responseValue ["username"] as? String{
                                    USERDEFAULTS.set(name, forKey: "userName")
                                    self.txtName.text = name
                                }
                                if let mobile = responseValue ["phone"] as? String{
                                    USERDEFAULTS.set(mobile, forKey: "userPhone")
                                    self.txtPhone.text = mobile
                                }
                                self.customIndicator.stopAnimating()
                                self.customIndicator.removeFromSuperview()
                            
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
    func updateProfileDetailsServiceCall(){
        var loginDict: Dictionary = [String: String]()
        if let userId = USERDEFAULTS.value(forKey: "uId") as? String{
            loginDict["user_id"] = userId
        }
        loginDict["username"] = self.txtName.text ?? ""
        loginDict["phone"] = self.txtPhone.text ?? ""

        print(loginDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.updateUserDetails, method: .post, parameters:loginDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                   // let dicJson = responseValue as NSDictionary
                    // print(dicJson)
                    
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            
                            if let userId = responseValue ["id"] as? String{
                                USERDEFAULTS.set(userId, forKey: "uId")
                            }
                            if let email = responseValue ["email"] as? String{
                                USERDEFAULTS.set(email, forKey: "userEmail")
                                self.txtEmail.text = email
                            }
                            if let name = responseValue ["username"] as? String{
                                USERDEFAULTS.set(name, forKey: "userName")
                                self.txtName.text = name
                            }
                            if let mobile = responseValue ["phone"] as? String{
                                USERDEFAULTS.set(mobile, forKey: "userPhone")
                                self.txtPhone.text = mobile
                            }
                            self.customIndicator.stopAnimating()
                            self.customIndicator.removeFromSuperview()
                            
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
