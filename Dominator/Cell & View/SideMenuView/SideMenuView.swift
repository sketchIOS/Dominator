//
//  SideMenuView.swift
//  GrofersCustomerApp
//
//  Created by Sketch Developer on 27/06/18.
//  Copyright © 2018 IOS DEVELOPER. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON

protocol SlidePanelDelegate: class {
    func selectedMenuSlidePanelView(_ menuId: Int?)
}

class SideMenuView: UIView,UITableViewDelegate,UITableViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var imageViewBack: UIImageView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgvUser: UIImageView!
    
    var isOpen = false
    var tap: UITapGestureRecognizer!
    // var dataArray:Array = [Any]()
    //var menuArray: [String] = ["Statistics","My Orders","Wallet","Logout"]
    var menuArray:Array = [Any]()
    var imageArray:Array = [Any]()
    var categoryArray:Array = [String]()
    var categoryImageArray:Array = [String]()

    var str_userName: String = ""
    var selectSectionIndex: Int = -1
    
    @IBOutlet weak var buttonProfile: UIButton!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var viewLowerMenu: UIView!
    
    weak var delegate: SlidePanelDelegate?
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func initialSetupWithData( _ index: Int){
      //  menuArray = arrayData
       // imageArray = arrayImage
        selectSectionIndex = index
        
        categoryArray = ["Categories","My Orders","My Quotes","My Addresses","My Cart","Log out"]
      //  categoryImageArray = ["product_list","add_product","upload_product","clearance","order_list","deliver","chat"]
        //["icon-newsfeed","icon-newsfeed"]
        print(menuArray)
        self.tableViewMenu.register(UINib(nibName: "SidePanelViewCell", bundle: nil), forCellReuseIdentifier: "kSidePanelViewCell")
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        
        
        /*
        if  let first_name = USERDEFAULTS.value(forKey: "first_name") {
            str_userName = first_name as! String
        }
        if  let last_name = USERDEFAULTS.value(forKey: "last_name"){
            str_userName = str_userName + " " + (last_name as! String)
        }
        if  let profile_image = USERDEFAULTS.value(forKey: "profile_image"){
            imgvProfile.sd_setShowActivityIndicatorView(true)
            imgvProfile.sd_setImage(with: URL(string: profile_image as! String), placeholderImage: UIImage(named: "placeholder.png"), options: .cacheMemoryOnly)
        }
        */
        lblName.text = USERDEFAULTS.value(forKey: "userName") as? String
        lblEmail.text = USERDEFAULTS.value(forKey: "userEmail") as? String
        
       // lblName.text = "ABC Enterprice"
       // lblEmail.text = "sketch.ios1@gmail.com"

        var frameT:CGRect = tableViewMenu.frame
        frameT.origin.x -= (tableViewMenu.frame.width)
        tableViewMenu.frame = frameT
        
        frameT = userView.frame
        frameT.origin.x -= (userView.frame.width)
        userView.frame = frameT
        
        //        frameT = viewLowerMenu.frame
        //        frameT.origin.x -= (viewLowerMenu.frame.width)
        //        viewLowerMenu.frame = frameT
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf(_:)))
        imageViewBack.addGestureRecognizer(tap)
        
        tableViewMenu.reloadData()
    }
    @IBAction func userProfileSelected(_ sender: Any) {
        delegate?.selectedMenuSlidePanelView(1001)
        stopingAnimation()

    }
    
    func loadingAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            var frameT:CGRect = self.tableViewMenu.frame
            frameT.origin.x = 0
            self.tableViewMenu.frame = frameT
            
            frameT = self.userView.frame
            frameT.origin.x = 0
            self.userView.frame = frameT
            
            //            frameT = self.viewLowerMenu.frame
            //            frameT.origin.x = 0
            //            self.viewLowerMenu.frame = frameT
            
        }, completion: nil)
    }
    
    func stopingAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            var frameT:CGRect = self.tableViewMenu.frame
            frameT.origin.x -= (self.tableViewMenu.frame.width)
            self.tableViewMenu.frame = frameT
            
            frameT = self.userView.frame
            frameT.origin.x -= (self.userView.frame.width)
            self.userView.frame = frameT
            
            //            frameT = self.viewLowerMenu.frame
            //            frameT.origin.x -= (self.viewLowerMenu.frame.width)
            //            self.viewLowerMenu.frame = frameT
            
        }, completion: { (finished: Bool) in
            //self.isOpen = true
            self .removeFromSuperview()
        })
    }
    
    // mark:- TableView Data Sorce
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     /*
        if isOpen {
//            if(section == selectSectionIndex){
//
//                return ((menuArray[section]["sub_category"] as? [NSDictionary])?.count)!
//            }
            return menuArray.count
        }
 
        return 0
 */
        return menuArray.count + categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"kSidePanelViewCell") as! SidePanelViewCell
        
        //cell.lblLine.isHidden = true
      //  cell.imageViewArrow.isHidden = true

        // cell.expandableCellImageView.image = UIImage(named: dataArray[indexPath.row])
//        if indexPath.row < menuArray.count {
//            cell.lblName.text = menuArray[indexPath.row] as? String
//            cell.imageViewMenuIcon.image = UIImage(named: imageArray[indexPath.row] as! String)
//            cell.imageViewArrow.isHidden = false
//            if indexPath.row == (menuArray.count - 1){
//                cell.lblLine.isHidden = false
//            }
//
//        }
        cell.lblName.text = categoryArray[indexPath.row]
      //  cell.imageViewMenuIcon.image = UIImage(named: categoryImageArray[indexPath.row])
        
        if indexPath.row == selectSectionIndex {
            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor = UIColor.gray
          //  cell.backgroundView = myCustomSelectionColorView
        }else{
            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor = UIColor.clear
           // cell.backgroundView = myCustomSelectionColorView
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let subCategory = menuArray[selectSectionIndex]["sub_category"] as? [NSDictionary]
        selectSectionIndex = indexPath.row
        tableViewMenu.reloadData()
        delegate?.selectedMenuSlidePanelView(indexPath.row - menuArray.count)
        stopingAnimation()
//        if (indexPath.row == menuArray.count-1) {
//            delegate?.logoutFromSlidePanelView()
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    @objc func dismissSelf(_ tapgesture: UITapGestureRecognizer) {
        self.stopingAnimation()
    }
    
    @objc func openHeaderClicked(_ button: UIButton) {
        selectSectionIndex = button.tag
        print(selectSectionIndex)
        isOpen = !isOpen
        tableViewMenu.reloadData()
    }
    
}
