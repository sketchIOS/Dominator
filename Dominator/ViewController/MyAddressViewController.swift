//
//  MyAddressViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 11/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MyAddressViewController: UIViewController,SlidePanelDelegate,AddressOptionsDelegate {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblAddressCount: UILabel!
    @IBOutlet weak var tableAddress: UITableView!
    let customIndicator = Indicator()
    var arrAddressList : [AddressObject] = []
    var comingFromCart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if comingFromCart {
            self.btnMenu.setImage(UIImage(named:"arrow-left"), for: .normal)
        } else {
            self.btnMenu.setImage(UIImage(named:"menu-bar"), for: .normal)
        }
        self.lblAddressCount.text = "\(self.arrAddressList.count) Saved Address"
        setTableViewDelegates()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    @IBAction func addNewAddressAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(vController, animated: false)
    }
    //MARK: - Side Menu
    @IBAction func btnMenuAction(_ sender: Any) {
        if comingFromCart {
            self.navigationController?.popViewController(animated: false)
        } else {
            let sidePanelView:SideMenuView = .fromNib()
            sidePanelView.frame = self.view.frame
            sidePanelView.delegate = self
            sidePanelView.initialSetupWithData(-1)
            self.view.addSubview(sidePanelView)
            sidePanelView.loadingAnimation()
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
    @objc func openOptionsToDeleteAddress(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedCell: AddressCell = self.tableAddress.cellForRow(at: indexPath) as! AddressCell

        var deleteOptionView = AddressOptionsView()
        deleteOptionView = .fromNib()
        deleteOptionView.frame = CGRect(x: Int(UIScreen.main.bounds.width - 133.0), y: 7, width: 120, height: 30)
        deleteOptionView.tag = sender.tag
        deleteOptionView.initialSetUp()
        deleteOptionView.delegate = self
        selectedCell.addSubview(deleteOptionView)
    }
    func selectedAddressForEdit(_ value: Int) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vController.isEditMode = true
        vController.addressDetails = self.arrAddressList[value]
        self.navigationController?.pushViewController(vController, animated: false)
    }
    func selectedAddressForDelete(_ value: Int) {
        deleteAddressServiceCall(value)
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
                    self.arrAddressList.removeAll()
                    self.tableAddress.reloadData()
                    self.lblAddressCount.text = "\(self.arrAddressList.count) Saved Address"
                    
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
        self.lblAddressCount.text = "\(self.arrAddressList.count) Saved Address"
    }
    func deleteAddressServiceCall(_ value: Int){
        var dataDict: Dictionary = [String: String]()
        
        dataDict["shipping_id"] = self.arrAddressList[value].aId
        
        print(dataDict)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.deleteAddress, method: .post, parameters:dataDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                            self.getAddressListFromApi()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MyAddressViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setTableViewDelegates(){
        tableAddress.register(UINib(nibName: "AddressCell", bundle: Bundle.main), forCellReuseIdentifier: "kAddressCell")
                tableAddress.estimatedRowHeight = 100
                tableAddress.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                tableAddress.rowHeight = UITableViewAutomaticDimension
        tableAddress.dataSource = self
        tableAddress.delegate = self
    }
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAddressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kAddressCell") as! AddressCell
        let addObj = self.arrAddressList[indexPath.row]
        cell.lblName.text = addObj.aShipName
        cell.lblAddress.text = "\(addObj.aAddress)\n\(addObj.aCity) - \(addObj.aZip)\n\(addObj.aState)"
        cell.lblPhone.text = "Mobile: " + addObj.aPhoneNo
        cell.btnOptions.addTarget(self, action: #selector(openOptionsToDeleteAddress(_:)), for: .touchUpInside)
        cell.btnOptions.tag = indexPath.row
        return  cell
    }
    // MARK: - Delegates
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
