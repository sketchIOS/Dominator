//
//  CategoryViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 08/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class CategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,SlidePanelDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    let customIndicator = Indicator()
    var arrCategoryList:[CategoryObject] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let arrCategoryImage = ["iconFire","iconInFloor","iconHome","iconDrug","iconCommercial","iconFirearm","iconDeposit","iconSafeLock"]
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cellSpace: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        getCategoryFromApi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (USERDEFAULTS.value(forKey: "isLoggedIn") != nil) {
            let loggedIn: Bool = USERDEFAULTS.value(forKey: "isLoggedIn") as! Bool
            if loggedIn {
                self.btnMenu.isHidden = false
            }else{
                self.btnMenu.isHidden = true
            }
        }else{
            self.btnMenu.isHidden = true
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
    //MARK: - Side Menu
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
    // MARK: Collection View
    func setCollectionViewDelegates(){
        
        let nib = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
        // let newView:NewSectionHeaderView = .fromNib()
        
        collectionView.register(nib, forCellWithReuseIdentifier: "MenuCollectionViewCell")
        
        
        //        if let flowLayout = collectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
        //            //           flowLayout.estimatedItemSize = CGSize(width: 150,height: 160)
        //            // flowLayout.estimatedItemSize = CGSize(width: 120,height: 100)
        //            flowLayout.estimatedItemSize = CGSize(width: collectionVw.frame.size.width / 2 ,height: 80)
        //        }
        
        screenSize = UIScreen.main.bounds
        screenWidth = collectionView.frame.size.width
        screenHeight = screenSize.height
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        if UIScreen.main.bounds.width == 375 { // x,6s,7,8
            layout.itemSize = CGSize(width: screenWidth/3 + 50, height: screenWidth/3 + 50)
        }else if UIScreen.main.bounds.width == 414{ // plus
            layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/3 + 25)
        }else{ //5s
            layout.itemSize = CGSize(width: screenWidth/3 + 20, height: screenWidth/3 + 25)
        }
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        
        return 1;
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        
        return 1;
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return arrCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        
        cell.lblType.text = arrCategoryList [indexPath.row].cName
        cell.img.sd_setShowActivityIndicatorView(true)
        let imgPath = APPURL.ImagePath + arrCategoryList [indexPath.row].cImage
        cell.img.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: ""), options: .cacheMemoryOnly)
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vController = mainStoryBoard.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
        vController.strSelectedCatId = arrCategoryList[indexPath.row].cId
        vController.strSelectedCat = arrCategoryList[indexPath.row].cName
        self.navigationController?.pushViewController(vController, animated: false)
    }
    //MARK: - API call for login
    func getCategoryFromApi(){
        
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
        
        Alamofire.request(APPURL.categoryListUrl, method: .get, parameters:nil , encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {
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
                                self.loadCategorydata(data: data)
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
    func loadCategorydata(data: [NSDictionary]){
        self.arrCategoryList.removeAll()
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
            self.arrCategoryList.append(catObj)
        }
        self.collectionView.reloadData()
    }
}

