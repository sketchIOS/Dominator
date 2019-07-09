//
//  Global.swift
//  GrofersCustomerApp
//
//  Created by Arka Banerjee on 19/07/18.
//  Copyright © 2018 IOS DEVELOPER. All rights reserved.
//

import Foundation
import UIKit

let USERDEFAULTS = UserDefaults.standard

struct APPURL {
    private static let BaseUrl = "http://lab-3.sketchdemos.com/P1137_fashzip_mobile_app/"
    static var loginUrl: String {
        return BaseUrl + "Webservice/user_login"
    }
    static var registrationUrl: String {
        return BaseUrl + "Webservice/user_signup"
    }
    static var forgotPasswordUrl: String {
        return BaseUrl + "Api/forgetpass"
    }
    static var categoryListUrl: String {
        return BaseUrl + "api/category_list"
    }
    static var allBannersUrl: String {
        return BaseUrl + "api/all-banner"
    }
    static var brandListUrl: String {
        return BaseUrl + "api/brand-list"
    }
    static var storeListUrl: String {
        return BaseUrl + "api/store_list"
    }//all-banner category_list brand-list store_list
}
func toastView(messsage : String, view: UIView ){
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height / 2, width: 300,  height : 40))
    //     toastLabel.backgroundColor = UIColor().HexToColor(hexString: primary_color)
    toastLabel.backgroundColor = UIColor.gray
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center;
    toastLabel.numberOfLines = 0
    view.addSubview(toastLabel)
    toastLabel.text = messsage
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
        toastLabel.alpha = 0.0
        
    })
}
func isValidEmail(email:String?) -> Bool {
    
    guard email != nil else { return false }
    
    let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
    return pred.evaluate(with: email)
}
class Indicator : UIActivityIndicatorView{
    
    func showIdicator( viewcontroller : UIViewController )
    {
        self.frame = viewcontroller.view.frame
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.color = UIColor.darkGray
        viewcontroller.view.addSubview(self)
    }
}
