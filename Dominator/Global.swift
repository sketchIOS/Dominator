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
  //  private static let BaseUrl = "http://lab-3.sketchdemos.com/P-1166-dominator/cadmin.php/webservice/"
    private static let BaseUrl = "https://www.dominatorsafes.com.au/admin/cadmin.php/webservice/"

    static var loginUrl: String {// Done
        return BaseUrl + "user_login"
    }
    static var registrationUrl: String { // Done
        return BaseUrl + "user_signup"
    }
    static var forgotPasswordUrl: String { // Done
        return BaseUrl + "user_forgotPassword"
    }
    static var resetPasswordUrl: String { // Done
        return BaseUrl + "user_resetPassword"
    }
    static var categoryListUrl: String { // Done
        return BaseUrl + "category_list"
    }
    static var subCategoryListUrl: String { // Done
        return BaseUrl + "sub_category_list"
    }
    static var productList: String { // Done
        return BaseUrl + "product_list"
    }
    static var insertQuote: String { // Done
        return BaseUrl + "insert_quote"
    }
    static var quoteList: String { // Done
        return BaseUrl + "quote_list"
    }
    static var shippingAddressList: String { // Done
        return BaseUrl + "user_shipping_address"
    }
    static var addAddress: String { // Done
        return BaseUrl + "insert_shipping_address"
    }
    static var editAddress: String { // Done
        return BaseUrl + "update_shipping_address"
    }
    static var deleteAddress: String { // Done
        return BaseUrl + "delete_shipping_address"
    }
    static var addToCart: String { // Done
        return BaseUrl + "add_to_cart"
    }
    static var userCartDetails: String { // Done
        return BaseUrl + "user_cart_details"
    }
    static var updateQuantity: String { // Done
        return BaseUrl + "update_quantity"
    }
    static var deleteProduct: String { // Done
        return BaseUrl + "delete_product"
    }
    static var placeOrder: String { // Done
        return BaseUrl + "insert_order"
    }
    static var orderList: String { // Done
        return BaseUrl + "user_order_details"
    }
    static var returnProduct: String { // Done
        return BaseUrl + "insert_refund_details"
    }
    static var needHelp: String { // Done
        return BaseUrl + "need_help"
    }//
    static var cancelOrder: String { // Done
        return BaseUrl + "insert_cancel_details"
    }//
    static var productAllPriceAllLockType: String { // Done
        return BaseUrl + "product_allprice_alllocktype"
    }//
    static var productPriceLockType: String { // Done
        return BaseUrl + "product_price_locktype"
    }
    static var userDetails: String { // Done
        return BaseUrl + "user_details"
    }
    static var updateUserDetails: String { // Done
        return BaseUrl + "update_user_details"
    }
    static var changePassword: String { // Done
        return BaseUrl + "change_password"
    }
   // public static let ImagePath = "http://lab-3.sketchdemos.com/P-1166-dominator/upload/product/"
    public static let ImagePath = "https://www.dominatorsafes.com.au/admin/upload/product/"
}
// MARK:- Help Functions

func toastView(messsage : String, view: UIView ){
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height / 2, width: 300,  height : 40))
    //     toastLabel.backgroundColor = UIColor().HexToColor(hexString: primary_color)
    toastLabel.backgroundColor = UIColor.lightGray
    toastLabel.textColor = UIColor.black
    toastLabel.textAlignment = NSTextAlignment.center;
    toastLabel.numberOfLines = 0
    view.addSubview(toastLabel)
    toastLabel.text = messsage
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    toastLabel.adjustsFontSizeToFitWidth = true
    UIView.animate(withDuration: 3.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
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
extension String {
    
    var isDigits: Bool {
        if isEmpty { return false }
        // The inverted set of .decimalDigits is every character minus digits
        let nonDigits = CharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: nonDigits) == nil
    }
    var isNumeric: Bool {
        if isEmpty { return false }
        
        return Double(self) != nil
    }
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeACall() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

