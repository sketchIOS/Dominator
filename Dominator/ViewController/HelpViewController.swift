//
//  HelpViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 28/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HelpViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHelp: UILabel!
    @IBOutlet weak var txtvHelp: UITextView!
    let customIndicator = Indicator()
    var isHelp = true
    var orderDetails = OrderObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addToolBar(textView: self.txtvHelp)
        if isHelp {
            self.lblHelp.text = "Write us your worries. We will help you shortly."
            self.lblTitle.text = "Help"
        } else { // Cancel
            self.lblHelp.text = "Write us your reason for cancel the product."
            self.lblTitle.text = "Cancel"
        }
        // Do any additional setup after loading the view.
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
    @IBAction func submitAction(_ sender: Any) {
        if self.txtvHelp.text.isEmpty {
            toastView(messsage: "Please enter your text", view: self.view)
        }else{
            if isHelp {
                helpServiceCall()
            }else{
                cancelServiceCall()
            }
        }
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
    // Mark: API
    func helpServiceCall(){
        var dataDict: Dictionary = [String: String]()
        dataDict["user_email"] = USERDEFAULTS.value(forKey: "userEmail") as? String
        dataDict["text"] = txtvHelp.text
   
        
        print(dataDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.needHelp, method: .post, parameters:dataDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            self.perform(#selector(self.backToParent), with: nil, afterDelay: 1.0)
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
    func cancelServiceCall(){
        var dataDict: Dictionary = [String: String]()
        dataDict["orderid"] = orderDetails.oId
        dataDict["reason"] = txtvHelp.text
        
        
        print(dataDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.cancelOrder, method: .post, parameters:dataDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            if self.isHelp {
                                self.perform(#selector(self.backToParent), with: nil, afterDelay: 1.0)
                            }else{
                                self.perform(#selector(self.backToMyOrder), with: nil, afterDelay: 1.0)
                            }
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
   @objc func backToParent() {
        self.navigationController?.popViewController(animated: false)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
