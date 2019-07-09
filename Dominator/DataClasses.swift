//
//  DataClasses.swift
//  FashZip
//
//  Created by IOS DEVELOPER on 19/09/18.
//  Copyright © 2018 IOS DEVELOPER. All rights reserved.
//

import UIKit

class ProductObject: NSObject {
    var pId : String = ""
    var pSubCategory : String = ""
    var pName : String = ""
    var pDescription : String = ""
    var pPrice : String = ""
    var pLockType : String = ""
    var pBrochure : String = ""
    var pArrImages : [NSDictionary] = []
    var pArrSpecification : [NSDictionary] = []
    var pArrFeatures : [NSDictionary] = []
    var pQuantity : String = ""

}
class CategoryObject: NSObject {
    var cId : String = ""
    var cName : String = ""
    var cImage : String = ""
    var cDescription : String = ""
}
class QuoteObject: NSObject {
    var qDate : String = ""
    var qProductName : String = ""
    var qArrImages : [NSDictionary] = []
    var qLockType : String = ""
    var qTotalPrice : String = ""
    var qInstallationPrice : String = ""
    var qEmail : String = ""
}
class AddressObject: NSObject {
    var aId : String = ""
    var aAddress : String = ""
    var aCity : String = ""
    var aState : String = ""
    var aZip : String = ""
    var aPhoneNo : String = ""
    var aShipName : String = ""
    var aCountry : String = ""
}
class OrderObject: NSObject {
    var oId : String = ""
    var oOrderNumber : String = ""
    var oDate : String = ""
    var oAmount : String = ""
    var oDeliveryStatus : String = ""
    var shippingAddress : AddressObject = AddressObject()
    var addedProducts : [ProductObject] = []
}
class CartDetailsObject: NSObject {
    var cId : String = ""
    var cOrderNumber : String = ""
    var cDate : String = ""
    var oAmount : String = ""
    var oDeliveryStatus : String = ""
    var addedProducts : [ProductObject] = []
}
