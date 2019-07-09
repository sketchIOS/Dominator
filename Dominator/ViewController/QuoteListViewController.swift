//
//  QuoteListViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 11/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class QuoteListViewController: UIViewController,SlidePanelDelegate {
    let customIndicator = Indicator()
    var arrQuoteList : [QuoteObject] = []
    
    @IBOutlet weak var tableQuote: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        getQuoteListFromApi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Side Menu
    @IBAction func btnMenuAction(_ sender: Any) {
        let sidePanelView:SideMenuView = .fromNib()
        sidePanelView.frame = self.view.frame
        sidePanelView.delegate = self
        sidePanelView.initialSetupWithData(-1)
        self.view.addSubview(sidePanelView)
        sidePanelView.loadingAnimation()
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
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
    func getQuoteListFromApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["user_id"] = USERDEFAULTS.value(forKey: "uId") as? String

        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.quoteList, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                                self.loadQuotedata(data: data)
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
    func loadQuotedata(data: [NSDictionary]){
        self.arrQuoteList.removeAll()
        for item in data {
            let qtObj = QuoteObject()
            if let name = item["product_name"] as? String {
                qtObj.qProductName = name
            }
            if let date = item["quote_date"] as? String {
                qtObj.qDate = date
            }
            if let lockType = item["lock_type"] as? String {
                qtObj.qLockType = lockType
            }
            if let email = item["customer_email"] as? String {
                qtObj.qEmail = email
            }
            if let total = item["total_price"] as? String {
                qtObj.qTotalPrice = total
            }
            if let instalPrice = item["installation_price"] as? String {
                qtObj.qInstallationPrice = instalPrice
            }
            if let images = item["images"] as? [NSDictionary] {
                qtObj.qArrImages = images
            }
            self.arrQuoteList.append(qtObj)
        }
        self.tableQuote.reloadData()
    }

}
extension QuoteListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setTableViewDelegates(){
        tableQuote.register(UINib(nibName: "QuoteCell", bundle: Bundle.main), forCellReuseIdentifier: "kQuoteCell")
        //        tableOrder.estimatedRowHeight = 35
        //        tableOrder.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        //        tableOrder.rowHeight = UITableViewAutomaticDimension
        tableQuote.dataSource = self
        tableQuote.delegate = self
    }
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrQuoteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kQuoteCell") as! QuoteCell
        cell.lblProductName.text = self.arrQuoteList [indexPath.row].qProductName
        cell.imgvProduct.sd_setShowActivityIndicatorView(true)
        if self.arrQuoteList[indexPath.row].qArrImages.count > 0 {
            cell.imgvProduct.sd_setShowActivityIndicatorView(true)
            let imgDic = self.arrQuoteList [indexPath.row].qArrImages[0]
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
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "QuoteDetailsViewController") as! QuoteDetailsViewController
        vController.quoteDetails = self.arrQuoteList [indexPath.row]
        self.navigationController?.pushViewController(vController, animated: false)
    }
    
}
