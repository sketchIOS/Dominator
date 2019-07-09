//
//  ProductDetailsViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 09/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ProductDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnFeatures: UIButton!
    @IBOutlet weak var btnSpecification: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBrochure: UIButton!
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var btnSendQuote: UIButton!
    @IBOutlet weak var btnCallDominator: UIButton!

    var isFeatured = true
    var productDetails = ProductObject()
    let customIndicator = Indicator()

    override func viewDidLoad() {
        super.viewDidLoad()
         loadProductDetails()
         setCollectionViewDelegates()
         setTableViewDelegates()
        btnBrochure.layer.borderWidth = 2.0
        btnBrochure.layer.borderColor = UIColor.white.cgColor
        btnSendQuote.layer.borderWidth = 2.0
        btnSendQuote.layer.borderColor = UIColor.white.cgColor
        btnOrder.layer.borderWidth = 2.0
        btnOrder.layer.borderColor = UIColor.white.cgColor
        btnCallDominator.layer.borderWidth = 2.0
        btnCallDominator.layer.borderColor = UIColor.white.cgColor
    }
    func loadProductDetails() {
        print(self.productDetails.pBrochure)
        self.lblProductName.text = self.productDetails.pName
        self.imgProduct.sd_setShowActivityIndicatorView(true)
        if self.productDetails.pArrImages.count > 0 {
            let imgDic = self.productDetails.pArrImages[0]
            let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
            self.imgProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
        }
        collectionView.reloadData()
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func productImageSelectionAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "ProductImageViewController") as! ProductImageViewController
        vController.productDetails = self.productDetails
        self.navigationController?.pushViewController(vController, animated: false)
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func featuresClicked(_ sender: Any) {
        self.btnFeatures.backgroundColor = UIColor.white
        self.btnSpecification.backgroundColor = UIColor.clear
        isFeatured = true
        self.tableView.reloadData()
    }
    @IBAction func specificationClicked(_ sender: Any) {
        self.btnFeatures.backgroundColor = UIColor.clear
        self.btnSpecification.backgroundColor = UIColor.white
        isFeatured = false
        self.tableView.reloadData()
    }
    @IBAction func brochureAction(_ sender: Any) {
        if self.productDetails.pBrochure.isEmpty {
            toastView(messsage: "No brochure is there", view: self.view)
        }else{
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "BrochureViewController") as! BrochureViewController
            vController.brochureLink = APPURL.ImagePath + self.productDetails.pBrochure
            self.navigationController?.pushViewController(vController, animated: false)
        }
    }
    @IBAction func orderAction(_ sender: Any) {
        if (USERDEFAULTS.value(forKey: "isLoggedIn") != nil) {
            let loggedIn: Bool = USERDEFAULTS.value(forKey: "isLoggedIn") as! Bool
            if loggedIn {
                getAllProductPriceServiceApi()
            }else{
                self.showAlertForSignInSignUp()
            }
        }else{
            self.showAlertForSignInSignUp()
        }
    }
    @IBAction func sendQuotesAction(_ sender: Any) {
        if (USERDEFAULTS.value(forKey: "isLoggedIn") != nil) {
            let loggedIn: Bool = USERDEFAULTS.value(forKey: "isLoggedIn") as! Bool
            if loggedIn {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let vController = mainStoryBoard.instantiateViewController(withIdentifier: "SendQuoteViewController") as! SendQuoteViewController
                vController.productDetails = self.productDetails
                self.navigationController?.pushViewController(vController, animated: false)
                
            }else{
              self.showAlertForSignInSignUp()
            }
        }else{
            self.showAlertForSignInSignUp()
        }
        
    }
    func showAlertForSignInSignUp() {
        let alertController = UIAlertController(title: title, message: "Please login / register to continue", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.launchSignInController()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func callDominatorAction(_ sender: Any) {
       // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    func openActionSheetForOrder(lockTypes: [String], prices: [String]) {
        
        let alertController = UIAlertController(title: title, message: "Select Lock Type", preferredStyle: UIAlertControllerStyle.actionSheet)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)

        for i in 0 ..< lockTypes.count {
            let floatV = Float(prices[i])
            let title = lockTypes[i] + " : $" + String(format: "%.2f", floatV!)
            
            let customAction = UIAlertAction(title: title, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                let arrName = result.title?.components(separatedBy: " : $")
                print(arrName![0] + arrName![1])
                self.addCartServiceApiForProduct(lockType: arrName![0], price: arrName![1])
            }
            alertController.addAction(customAction)
        }
        let descriptionAction = UIAlertAction(title: "Wholesale discount will be applied at time of invoice", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(descriptionAction)

        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Size Collection View
    func setCollectionViewDelegates(){
        
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        // let newView:NewSectionHeaderView = .fromNib()
        collectionView.register(nib, forCellWithReuseIdentifier: "kProductCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //UICollectionViewDelegateFlowLayout methods
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
//    {
//
//        return 0;
//    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
//    {
//
//        return 0;
//    }
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productDetails.pArrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        cell.imgvProduct.sd_setShowActivityIndicatorView(true)
        let imgDic = self.productDetails.pArrImages[indexPath.row]
        let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
        cell.imgvProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : ProductCollectionViewCell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
        self.imgProduct.image = cell.imgvProduct.image
    }
    func getAllProductPriceServiceApi(){
        var paramDict: Dictionary = [String: String]()
        paramDict["product_id"] = self.productDetails.pId
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.productAllPriceAllLockType, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                    print(responseValue)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            if let data = responseValue["data"] as? NSDictionary, let locktype = data["lock_type"] as? [String], let price = data["price"] as? [String] {
                                   self.openActionSheetForOrder(lockTypes: locktype, prices: price)
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
    func addCartServiceApiForProduct(lockType: String, price: String){
        var paramDict: Dictionary = [String: String]()
        paramDict["user_id"] = USERDEFAULTS.value(forKey: "uId") as? String
        paramDict["product_id"] = self.productDetails.pId
        paramDict["lock_type"] = lockType
        paramDict["price"] = price

        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.addToCart, method: .post, parameters:paramDict , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success (let value):
                if let responseValue = value as?[String: Any]{
                     print(responseValue)
                    if let status = responseValue["status"] as? Int {
                        if status == 1{
                            let message = responseValue["message"] as! String
                            toastView(messsage: message, view: self.view)
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vController = mainStoryBoard.instantiateViewController(withIdentifier: "PlaceOrderViewController") as! PlaceOrderViewController
                            vController.productDetails = self.productDetails
                            self.navigationController?.pushViewController(vController, animated: false)
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
}
extension ProductDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setTableViewDelegates(){
        tableView.register(UINib(nibName: "ProductFeaturesCell", bundle: Bundle.main), forCellReuseIdentifier: "kProductFeaturesCell")
        tableView.estimatedRowHeight = 40
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFeatured ? self.productDetails.pArrFeatures.count : self.productDetails.pArrSpecification.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kProductFeaturesCell") as! ProductFeaturesCell
        
        if isFeatured {
            let featureDic = self.productDetails.pArrFeatures[indexPath.row]
            if let name = featureDic["feature"] as? String {
                cell.lblName.text = name
            }
        }else{
            let featureDic = self.productDetails.pArrSpecification[indexPath.row]
            if let name = featureDic["specification"] as? String {
                cell.lblName.text = name
            }
        }
        
        return  cell
    }
    // MARK: - Delegates
    
}
