//
//  MyOrderViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 10/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MyOrderViewController: UIViewController,SlidePanelDelegate {

    @IBOutlet weak var tableOrder: UITableView!
    let customIndicator = Indicator()
    var arrOrderList : [OrderObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setTableViewDelegates()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getOrderListFromApi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @IBAction func btnMenuAction(_ sender: Any) {
        let sidePanelView:SideMenuView = .fromNib()
        sidePanelView.frame = self.view.frame
        sidePanelView.delegate = self
        sidePanelView.initialSetupWithData(-1)
        self.view.addSubview(sidePanelView)
        sidePanelView.loadingAnimation()
    }
    func selectedMenuSlidePanelView(_ menuId: Int?) {
        switch menuId { //["Categories","My Orders","My Quotes","My Addresses","Log out"]
        case 0?:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
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
        case 4?:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "PlaceOrderViewController") as! PlaceOrderViewController
            vController.comingFromSideMenu = true
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
    

    func getOrderListFromApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["user_id"] = USERDEFAULTS.value(forKey: "uId") as? String
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.orderList, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                                self.loadOrderdata(data: data)
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
    func loadOrderdata(data: [NSDictionary]){
        self.arrOrderList.removeAll()
        for item in data {
            let orObj = OrderObject()
            if let id = item["id"] as? String {
                orObj.oId = id
            }
            if let ordernumber = item["order_number"] as? String {
                orObj.oOrderNumber = ordernumber
            }
            if let date = item["date"] as? String {
                orObj.oDate = date
            }
            if let paymentamount = item["payment_amount"] as? Float {
                orObj.oAmount = String(paymentamount)
            }
            if let deliverystatus = item["delivery_status"] as? String {
                orObj.oDeliveryStatus = deliverystatus
            }
            if let address = item["address"] as? String {
                orObj.shippingAddress.aAddress = address
            }
            if let city = item["city"] as? String {
                orObj.shippingAddress.aCity = city
            }
            if let state = item["state"] as? String {
                orObj.shippingAddress.aState = state
            }
            if let pin = item["pin"] as? String {
                orObj.shippingAddress.aZip = pin
            }
            if let phone = item["phone_number"] as? String {
                orObj.shippingAddress.aPhoneNo = phone
            }
            if let shipname = item["ship_name"] as? String {
                orObj.shippingAddress.aShipName = shipname
            }
            if let country = item["country"] as? String {
                orObj.shippingAddress.aCountry = country
            }
            orObj.addedProducts.removeAll()
            if let productdetails = item["product_details"] as? [NSDictionary] {
                for itemP in productdetails {
                    let proObj = ProductObject()
                    if let id = itemP["productId"] as? String {
                        proObj.pId = id
                    }
                    if let subCat = itemP["category"] as? NSDictionary, let subCatName = subCat["category_name"] as? String {
                        proObj.pSubCategory = subCatName
                    }
                    if let name = itemP["product_name"] as? String {
                        proObj.pName = name
                    }
                    if let description = itemP["description"] as? String {
                        proObj.pDescription = description
                    }
                    if let priceDict = itemP["product_lock_price"] as? NSDictionary{
                        if let locktype = priceDict["lock_type"] as? String {
                            proObj.pLockType = locktype
                        }
                        if let price = priceDict["price"] as? String {
                            proObj.pPrice = price
                        }
                    }
                    if let images = itemP["images"] as? [NSDictionary] {
                        proObj.pArrImages = images
                    }
                    if let qtyDict = itemP["product_quantity"] as? NSDictionary, let quantity = qtyDict["quantity"] as? String {
                        proObj.pQuantity = quantity
                    }
                    orObj.addedProducts.append(proObj)
                }
            }
            self.arrOrderList.append(orObj)
        }
        self.tableOrder.reloadData()
    }

}
extension MyOrderViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setTableViewDelegates(){
        tableOrder.register(UINib(nibName: "MyOrderCell", bundle: Bundle.main), forCellReuseIdentifier: "kMyOrderCell")
//        tableOrder.estimatedRowHeight = 35
//        tableOrder.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
//        tableOrder.rowHeight = UITableViewAutomaticDimension
        tableOrder.dataSource = self
        tableOrder.delegate = self
    }
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOrderList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMyOrderCell") as! MyOrderCell
        cell.lblProductName.text = self.arrOrderList[indexPath.row].addedProducts[0].pName
        let dateFormatter: DateFormatter = DateFormatter()//
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: NSDate = dateFormatter.date(from: self.arrOrderList[indexPath.row].oDate)! as NSDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch self.arrOrderList[indexPath.row].oDeliveryStatus {
        case "0":
            cell.lblOrderStatus.backgroundColor = UIColor.green
            cell.lblProductInfo.text = "Order In progress. Placed on: " + dateFormatter.string(from: date as Date)
        case "1":
            cell.lblOrderStatus.backgroundColor = UIColor.blue
            cell.lblProductInfo.text = "Order Delivered. Placed on: " + dateFormatter.string(from: date as Date)
        case "2":
            cell.lblOrderStatus.backgroundColor = UIColor.red
            cell.lblProductInfo.text = "Order Rejected."
        case "3":
            cell.lblOrderStatus.backgroundColor = UIColor.orange
            cell.lblProductInfo.text = "Order Returned."
        case "4":
            cell.lblOrderStatus.backgroundColor = UIColor.red
            cell.lblProductInfo.text = "Order Canceled."
        default:
            print("default")
        }
        cell.imgvProduct.sd_setShowActivityIndicatorView(true)
        if self.arrOrderList[indexPath.row].addedProducts[0].pArrImages.count > 0 {
            cell.imgvProduct.sd_setShowActivityIndicatorView(true)
            let imgDic = self.arrOrderList[indexPath.row].addedProducts[0].pArrImages[0]
            let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
            cell.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
        }
        return  cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    // MARK: - Delegates
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        vController.orderDetails = self.arrOrderList[indexPath.row]
        self.navigationController?.pushViewController(vController, animated: false)
    }
    
}
