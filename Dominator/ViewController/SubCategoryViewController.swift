//
//  SubCategoryViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 08/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SubCategoryViewController: UIViewController {
    let customIndicator = Indicator()
    var arrSubCategoryList:[CategoryObject] = []
    var arrProductList:[ProductObject] = []

    var strTitle = "Product List"
    var strSelectedCat = ""
    var strSelectedCatId = ""
    var isProductList = false
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSelectedTitle: UILabel!

    @IBOutlet weak var tableSubCategory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = strTitle
        self.lblSelectedTitle.text = strSelectedCat
        self.setTableViewDelegates()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        if self.isProductList {
            getProductListFromApi()
        } else {
            getSubCategoryFromApi()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func showViewFullDetails(_ sender: UIButton) {
        if self.isProductList { // load product details
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vController.productDetails = self.arrProductList[sender.tag]
            self.navigationController?.pushViewController(vController, animated: false)
        }else{ // load sub sub category
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let selectedCell: ProductListCell = self.tableSubCategory.cellForRow(at: indexPath) as! ProductListCell
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            vController.strTitle = self.strSelectedCat
            vController.strSelectedCat = selectedCell.lblProductName.text!
            vController.strSelectedCatId = self.arrSubCategoryList[sender.tag].cId
            vController.isProductList = true
            self.navigationController?.pushViewController(vController, animated: false)
        }
    }
    //MARK: - API call for login
    func getSubCategoryFromApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["id"] = self.strSelectedCatId
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.subCategoryListUrl, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                                self.loadSubCategorydata(data: data)
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
    func getProductListFromApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["sub_category_id"] = self.strSelectedCatId
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.productList, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                                self.loadProductListdata(data: data)
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
    func loadSubCategorydata(data: [NSDictionary]){
        self.arrSubCategoryList.removeAll()
        for item in data {
            let catObj = CategoryObject()
            if let id = item["id"] as? String {
                catObj.cId = id
            }
            if let name = item["name"] as? String {
                catObj.cName = name
            }
            if let image = item["image"] as? String {
                catObj.cImage = image
            }
            if let description = item["description"] as? String {
                catObj.cDescription = description
            }
            self.arrSubCategoryList.append(catObj)
        }
        if self.arrSubCategoryList.count == 0 {
            toastView(messsage: "No Category Found", view: self.view)
        }
        self.tableSubCategory.reloadData()
    }
    func loadProductListdata(data: [NSDictionary]){
        self.arrProductList.removeAll()
        for item in data {
            let proObj = ProductObject()
            if let id = item["id"] as? String {
                proObj.pId = id
            }
            if let subCat = item["sub_category"] as? String {
                proObj.pSubCategory = subCat
            }
            if let name = item["product_name"] as? String {
                proObj.pName = name
            }
            if let description = item["description"] as? String {
                proObj.pDescription = description
            }
            if let price = item["price"] as? String {
                proObj.pPrice = price
            }
            if let images = item["images"] as? [NSDictionary] {
                proObj.pArrImages = images
            }
            if let specification = item["specification"] as? [NSDictionary] {
                proObj.pArrSpecification = specification
            }
            if let feature = item["feature"] as? [NSDictionary] {
                proObj.pArrFeatures = feature
            }
            if let brochurefile = item["brochure_file"] as? String {
                proObj.pBrochure = brochurefile
            }
            self.arrProductList.append(proObj)
        }
        if self.arrProductList.count == 0 {
            toastView(messsage: "No Product Found", view: self.view)
        }
        self.tableSubCategory.reloadData()
    }
}
extension SubCategoryViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setTableViewDelegates(){
        tableSubCategory.register(UINib(nibName: "ProductListCell", bundle: Bundle.main), forCellReuseIdentifier: "kProductListCell")
        tableSubCategory.estimatedRowHeight = 100
        tableSubCategory.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableSubCategory.rowHeight = UITableViewAutomaticDimension
        tableSubCategory.dataSource = self
        tableSubCategory.delegate = self
    }
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.isProductList ? self.arrProductList.count : self.arrSubCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kProductListCell") as! ProductListCell
//        cell.lblOrderId.text = "Order id: #123213"
        cell.btnViewFull.layer.borderColor = UIColor.white.cgColor
        cell.btnViewFull.layer.borderWidth = 2.0
        cell.btnViewFull.tag = indexPath.row
        cell.btnViewFull.addTarget(self, action: #selector(showViewFullDetails(_:)), for: .touchUpInside)
        if self.isProductList {
            if arrProductList[indexPath.row].pArrImages.count > 0 {
                cell.imgvProduct.sd_setShowActivityIndicatorView(true)
                let imgDic = arrProductList [indexPath.row].pArrImages[0]
                let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
                cell.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
            }
            cell.btnViewFull.setTitle("View Product", for: .normal)
            cell.lblProductName.text = self.arrProductList[indexPath.row].pName
            
            if self.arrProductList[indexPath.row].pDescription.count > 0 {
                let htmlData = NSString(string: self.arrProductList[indexPath.row].pDescription).data(using: String.Encoding.unicode.rawValue)
                cell.lblProductDescription.attributedText = try! NSAttributedString(data: htmlData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } else {
            let imgPath = APPURL.ImagePath + arrSubCategoryList [indexPath.row].cImage
            cell.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)//product
            
            cell.btnViewFull.setTitle("View the Full Range", for: .normal)
            cell.lblProductName.text = self.arrSubCategoryList[indexPath.row].cName
            
            if self.arrSubCategoryList[indexPath.row].cDescription.count > 0 {
                let htmlData = NSString(string: self.arrSubCategoryList[indexPath.row].cDescription).data(using: String.Encoding.unicode.rawValue)
                cell.lblProductDescription.attributedText = try! NSAttributedString(data: htmlData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        }
        cell.lblProductDescription.textColor = UIColor.white

        
        return  cell
    }
    // MARK: - Delegates
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
