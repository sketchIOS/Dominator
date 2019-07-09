//
//  OrderDetailsViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 11/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var viewLower: UIView!
    @IBOutlet weak var viewProducts: UIView!
    @IBOutlet weak var tableOrderProduct: UITableView!
    @IBOutlet weak var btnReturnCancel: UIButton!
    @IBOutlet weak var vwReturnHelp: UIView!
    @IBOutlet weak var vwShipping: UIView!
    @IBOutlet weak var lblShippingDetails: UILabel!
    @IBOutlet weak var imgvStatus: UIImageView!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    var orderDetails = OrderObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadOrderDetails()
        setTableViewDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadOrderDetails() {
        self.lblOrderId.text = "Order Id: #" + self.orderDetails.oOrderNumber
        let dateFormatter: DateFormatter = DateFormatter()//
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: NSDate = dateFormatter.date(from: self.orderDetails.oDate)! as NSDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let floatV = Float(orderDetails.oAmount)
        self.lblTotalPrice.text = "Total Price: $" + String(format: "%.2f", floatV!)

//        frameP = self.viewLower.frame
//        frameP.origin.y = self.viewProducts.frame.origin.y + self.viewProducts.frame.height
//        self.viewLower.frame = frameP
        
        
        switch self.orderDetails.oDeliveryStatus {
        case "0":
            self.imgvStatus.backgroundColor = UIColor.green
            self.lblDeliveryTime.text = "In progress. Order Placed on: " + dateFormatter.string(from: date as Date)
            self.btnReturnCancel.setTitle("Cancel", for: .normal)
        case "1":
            self.imgvStatus.backgroundColor = UIColor.blue
            self.lblDeliveryTime.text = "Delivered. Order Placed on: " + dateFormatter.string(from: date as Date)
            self.btnReturnCancel.setTitle("Return", for: .normal)
        case "2":
            self.imgvStatus.backgroundColor = UIColor.red
            self.lblDeliveryTime.text = "Rejected. Order Placed on: " + dateFormatter.string(from: date as Date)
            self.vwReturnHelp.isHidden = true
            self.vwShipping.isHidden = true
        case "3":
            self.imgvStatus.backgroundColor = UIColor.orange
            self.lblDeliveryTime.text = "Returned. Order Placed on: " + dateFormatter.string(from: date as Date)
            self.vwReturnHelp.isHidden = true
            self.vwShipping.isHidden = true
        case "4":
            self.imgvStatus.backgroundColor = UIColor.red
            self.lblDeliveryTime.text = "Canceled. Order Placed on: " + dateFormatter.string(from: date as Date)
            self.vwReturnHelp.isHidden = true
            self.vwShipping.isHidden = true
        default:
            print("default")
        }
        self.lblShippingDetails.text = "\(self.orderDetails.shippingAddress.aShipName)\n\(self.orderDetails.shippingAddress.aAddress)\n\(self.orderDetails.shippingAddress.aCity) - \(self.orderDetails.shippingAddress.aZip)\n\(self.orderDetails.shippingAddress.aState), \(self.orderDetails.shippingAddress.aCountry)\nMobile: \(self.orderDetails.shippingAddress.aPhoneNo)"
        
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func returnAction(_ sender: Any) {
        if self.orderDetails.oDeliveryStatus == "0" { // in progress mode
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            vController.isHelp = false
            vController.orderDetails = self.orderDetails
            self.navigationController?.pushViewController(vController, animated: false)
        }else{ // delivered
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "ReturnViewController") as! ReturnViewController
            vController.orderDetails = self.orderDetails
            self.navigationController?.pushViewController(vController, animated: false)
        }
    }
    @IBAction func needHelpAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        self.navigationController?.pushViewController(vController, animated: false)
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
extension OrderDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setTableViewDelegates(){
        //
        tableOrderProduct.register(UINib(nibName: "OrderDetailsProductCell", bundle: Bundle.main), forCellReuseIdentifier: "kOrderDetailsProductCell")
        tableOrderProduct.dataSource = self
        tableOrderProduct.delegate = self
        
    }
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetails.addedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kOrderDetailsProductCell") as! OrderDetailsProductCell
        
        cell.lblName.text = self.orderDetails.addedProducts[indexPath.row].pName
        let floatV = Float(self.orderDetails.addedProducts[indexPath.row].pPrice)
        cell.lblAmaunt.text = "$" + String(format: "%.2f", floatV!)
        cell.lblQty.text = "Quantity: " + self.orderDetails.addedProducts[indexPath.row].pQuantity
        cell.lblLockType.text = "Locktype: " + self.orderDetails.addedProducts[indexPath.row].pLockType

        cell.imgvProduct.sd_setShowActivityIndicatorView(true)
        if self.orderDetails.addedProducts[indexPath.row].pArrImages.count > 0 {
            let imgDic = self.orderDetails.addedProducts[indexPath.row].pArrImages[0]
            let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
            cell.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
        }
        return  cell
        
    }
    // MARK: - Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0

    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
   }
}
