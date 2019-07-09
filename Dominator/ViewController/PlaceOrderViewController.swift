//
//  PlaceOrderViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 10/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PlaceOrderViewController: UIViewController,SlidePanelDelegate {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewPlaceOrder: UIView!
    @IBOutlet weak var viewDeliveryAddress: UIView!
    @IBOutlet weak var viewProducts: UIView!
    @IBOutlet weak var tableProducts: UITableView!
    @IBOutlet weak var btnContinueShop: UIButton!
    @IBOutlet weak var tableAddress: UITableView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    var productDetails = ProductObject()
    let customIndicator = Indicator()
    var arrAddressList : [AddressObject] = []
    var cartDetails = CartDetailsObject()
    var selectedAddress = 0
    var comingFromSideMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comingFromSideMenu {
            self.btnMenu.setImage(UIImage(named:"menu-bar"), for: .normal)
        } else {
            self.btnMenu.setImage(UIImage(named:"arrow-left"), for: .normal)
        }
        
        btnContinueShop.layer.borderWidth = 2.0
        btnContinueShop.layer.borderColor = UIColor.white.cgColor
        setTableViewDelegates()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getCartDetailsApi()
        getAddressListFromApi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @objc func decreamantQuantityAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedCell: CartProductCell = self.tableProducts.cellForRow(at: indexPath) as! CartProductCell
        
        if selectedCell.lblQty.text == "1" {
            return
        }else{
            var value: Int = Int(selectedCell.lblQty.text!)!
            value = value - 1
            selectedCell.lblQty.text = String(value)
            updateProductQuantityApi(self.cartDetails.addedProducts[sender.tag].pId, selectedCell.lblQty.text!)
        }
    }
    @objc func increamentQuantityAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedCell: CartProductCell = self.tableProducts.cellForRow(at: indexPath) as! CartProductCell
        
        if selectedCell.lblQty.text == "99" {
            return
        }else{
            var value: Int = Int(selectedCell.lblQty.text!)!
            value = value + 1
            selectedCell.lblQty.text = String(value)
            updateProductQuantityApi(self.cartDetails.addedProducts[sender.tag].pId, selectedCell.lblQty.text!)
        }
    }
    @objc func deleteProductAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: title, message: "Do you want to delete the product?", preferredStyle: UIAlertControllerStyle.alert)
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.deleteProductApi(self.cartDetails.addedProducts[sender.tag].pId)
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func backAction(_ sender: Any) {
        if comingFromSideMenu {
            let sidePanelView:SideMenuView = .fromNib()
            sidePanelView.frame = self.view.frame
            sidePanelView.delegate = self
            sidePanelView.initialSetupWithData(-1)
            self.view.addSubview(sidePanelView)
            sidePanelView.loadingAnimation()
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    func selectedMenuSlidePanelView(_ menuId: Int?) {
        switch menuId { //["Categories","My Orders","My Quotes","My Addresses","Log out"]
        case 0?:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            self.navigationController?.pushViewController(vController, animated: false)
        case 1?:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "MyOrderViewController") as! MyOrderViewController
            self.navigationController?.pushViewController(vController, animated: false)
        case 2?:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "QuoteListViewController") as! QuoteListViewController
            self.navigationController?.pushViewController(vController, animated: false)
        case 3?:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "MyAddressViewController") as! MyAddressViewController
            self.navigationController?.pushViewController(vController, animated: false)
        case 5?:
            USERDEFAULTS.set(false, forKey: "isLoggedIn")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.launchRootController()
        case 1001?:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
            self.navigationController?.pushViewController(vController, animated: false)
        default:
            print(menuId)
        }
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        if self.cartDetails.addedProducts.count > 0 {
            if self.arrAddressList.count > 0 {
                placeOrderServiceApi()
            }else{
                toastView(messsage: "Please add delivery address", view: self.view)
            }
        } else {
            toastView(messsage: "Please add some products", view: self.view)
        }
    }
    @IBAction func changeOrAddAddressAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "MyAddressViewController") as! MyAddressViewController
        vController.comingFromCart = true
        self.navigationController?.pushViewController(vController, animated: false)
    }
    
     @IBAction func continueShoppingAction(_ sender: Any) {
        backToCategory()
     }
   @objc func addressSelection(_ sender: UIButton) {
        selectedAddress = sender.tag
        tableAddress.reloadData()
    }
    func getAddressListFromApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["user_id"] = USERDEFAULTS.value(forKey: "uId") as? String
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.shippingAddressList, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    // print(dicJson)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            if let data = responseValue["data"] as? [NSDictionary]{
                                print(data)
                                self.loadAddressdata(data: data)
                            }
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                }
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    func getCartDetailsApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["user_id"] = USERDEFAULTS.value(forKey: "uId") as? String
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.userCartDetails, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{

                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            if let data = responseValue["data"] as? [NSDictionary]{
                                print(data)
                                self.loadCartdata(data: data)
                            }
                        }
                        else{
                            self.cartDetails = CartDetailsObject()
                            self.tableProducts.reloadData()
                            self.lblTotalPrice.text = "Total Price: $0.00"

                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                }
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    func updateProductQuantityApi(_ productId: String, _ productQty: String){
        var paramDict: Dictionary = [String: String]()
        paramDict["orderid"] = self.cartDetails.cId
        paramDict["product_id"] = productId
        paramDict["quantity"] = productQty
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.updateQuantity, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            self.getCartDetailsApi()
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                }
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    func deleteProductApi(_ productId: String){
        var paramDict: Dictionary = [String: String]()
        paramDict["orderid"] = self.cartDetails.cId
        paramDict["product_id"] = productId

        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.deleteProduct, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            self.getCartDetailsApi()
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                }
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    func placeOrderServiceApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["order_id"] = self.cartDetails.cId
        paramDict["shipping_id"] = self.arrAddressList[selectedAddress].aId
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.placeOrder, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    // print(dicJson)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            self.cartDetails = CartDetailsObject()
                            self.tableProducts.reloadData()
                            self.lblTotalPrice.text = "Total Price: $0.00"

                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                            self.perform(#selector(self.backToCategory), with: nil, afterDelay: 3.0)
                        }
                        else{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                        }
                    }
                }
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                toastView(messsage: error.localizedDescription, view: self.view)
                self.customIndicator.stopAnimating()
                self.customIndicator.removeFromSuperview()
            }
        })
        
    }
    func loadCartdata(data: [NSDictionary]){
        let dictDetails = data[0]

           if let id = dictDetails["id"] as? String {
                cartDetails.cId = id
            }
            if let orderNumber = dictDetails["order_number"] as? String {
                cartDetails.cOrderNumber = orderNumber
            }
           if let date = dictDetails["date"] as? String {
            cartDetails.cDate = date
           }
           if let status = dictDetails["delivery_status"] as? String {
            cartDetails.oDeliveryStatus = status
           }
           if let amount = dictDetails["payment_amount"] as? Float {
            cartDetails.oAmount = String(amount)
           }
          cartDetails.addedProducts.removeAll()
          if let productdetails = dictDetails["product_details"] as? [NSDictionary] {
            for item in productdetails {
                let proObj = ProductObject()
                if let id = item["productId"] as? String {
                    proObj.pId = id
                }
                if let subCat = item["category"] as? NSDictionary, let subCatName = subCat["category_name"] as? String {
                    proObj.pSubCategory = subCatName
                }
                if let name = item["product_name"] as? String {
                    proObj.pName = name
                }
                if let description = item["description"] as? String {
                    proObj.pDescription = description
                }
                if let priceDict = item["product_lock_price"] as? NSDictionary{
                    if let locktype = priceDict["lock_type"] as? String {
                        proObj.pLockType = locktype
                    }
                    if let price = priceDict["price"] as? String {
                        proObj.pPrice = price
                    }
                }
                if let images = item["images"] as? [NSDictionary] {
                    proObj.pArrImages = images
                }
                if let qtyDict = item["product_quantity"] as? NSDictionary, let quantity = qtyDict["quantity"] as? String {
                    proObj.pQuantity = quantity
                }
                cartDetails.addedProducts.append(proObj)
            }
          }
        
        self.tableProducts.reloadData()
        let floatV = Float(cartDetails.oAmount)
        self.lblTotalPrice.text = "Total Price: $" + String(format: "%.2f", floatV!)
        //
        var frameP = self.viewProducts.frame
        if cartDetails.addedProducts.count > 1 {
            frameP.size.height = CGFloat(220)
        } else {
            frameP.size.height = CGFloat(130 * cartDetails.addedProducts.count)
        }
        self.viewProducts.frame = frameP
        
        frameP = self.viewDeliveryAddress.frame
        frameP.origin.y = self.viewProducts.frame.origin.y + self.viewProducts.frame.height + 10
        self.viewDeliveryAddress.frame = frameP
        
        frameP = self.viewPlaceOrder.frame
        frameP.origin.y = self.viewDeliveryAddress.frame.origin.y + self.viewDeliveryAddress.frame.height
        self.viewPlaceOrder.frame = frameP
        
    }
    func loadAddressdata(data: [NSDictionary]){
        self.arrAddressList.removeAll()
        for item in data {
            let addObj = AddressObject()
            if let id = item["id"] as? String {
                addObj.aId = id
            }
            if let address = item["address"] as? String {
                addObj.aAddress = address
            }
            if let city = item["city"] as? String {
                addObj.aCity = city
            }
            if let state = item["state"] as? String {
                addObj.aState = state
            }
            if let pin = item["pin"] as? String {
                addObj.aZip = pin
            }
            if let phone = item["phone_number"] as? String {
                addObj.aPhoneNo = phone
            }
            if let shipname = item["ship_name"] as? String {
                addObj.aShipName = shipname
            }
            if let country = item["country"] as? String {
                addObj.aCountry = country
            }
            self.arrAddressList.append(addObj)
        }
        self.tableAddress.reloadData()
    }
    @objc func showWholeSaleMsg() {
        toastView(messsage: "Wholesale discount will be applied at time of invoice.", view: self.view)
        if !self.comingFromSideMenu {
            self.view.isUserInteractionEnabled = false
            self.perform(#selector(self.backToCategory), with: nil, afterDelay: 3.0)
        }
    }
    @objc func backToCategory() {
        // back to category page
        let arrV = self.navigationController?.viewControllers
        for vc in arrV! {
            if vc.isKind(of: CategoryViewController.self){
                let catVC = vc as! CategoryViewController
                self.navigationController?.popToViewController(catVC, animated: false)
                break
            }
        }
    }
}
extension PlaceOrderViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setTableViewDelegates(){
        tableAddress.register(UINib(nibName: "PlacedOrderAddressSelectionCell", bundle: Bundle.main), forCellReuseIdentifier: "kPlacedOrderAddressSelectionCell")
        tableAddress.estimatedRowHeight = 35
        tableAddress.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableAddress.rowHeight = UITableViewAutomaticDimension
        tableAddress.dataSource = self
        tableAddress.delegate = self
        //
        tableProducts.register(UINib(nibName: "CartProductCell", bundle: Bundle.main), forCellReuseIdentifier: "kCartProductCell")
        tableProducts.dataSource = self
        tableProducts.delegate = self

    }
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableAddress {
            return self.arrAddressList.count
        }
        return cartDetails.addedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableAddress {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kPlacedOrderAddressSelectionCell") as! PlacedOrderAddressSelectionCell
            
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(addressSelection(_:)), for: .touchUpInside)
            if selectedAddress == indexPath.row {
                cell.btnCheck.isSelected = true
            }else{
                cell.btnCheck.isSelected = false
            }
            let addObj = self.arrAddressList[indexPath.row]
            
            cell.lblAddress.text = "\(addObj.aShipName)\n\(addObj.aAddress)\n\(addObj.aCity) - \(addObj.aZip)\n\(addObj.aState)"
            return  cell
        }
        // Proct Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCartProductCell") as! CartProductCell
        
        cell.lblSeriesName.text = self.cartDetails.addedProducts[indexPath.row].pSubCategory
        cell.lblModel.text = "Model: " +  self.cartDetails.addedProducts[indexPath.row].pName
        cell.lblLockType.text = "Locktype: " +  self.cartDetails.addedProducts[indexPath.row].pLockType
        cell.lblQty.text = self.cartDetails.addedProducts[indexPath.row].pQuantity
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(increamentQuantityAction(_:)), for: .touchUpInside)
        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.addTarget(self, action: #selector(decreamantQuantityAction(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteProductAction(_:)), for: .touchUpInside)

        return  cell
        
    }
    // MARK: - Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableProducts {
            return 130.0
        }
        return tableView.rowHeight
    }

    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
