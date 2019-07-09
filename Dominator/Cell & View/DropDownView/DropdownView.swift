//
//  DropdownView.swift
//  FashZip
//
//  Created by Arka Banerjee on 12/09/18.
//  Copyright © 2018 IOS DEVELOPER. All rights reserved.
//

import UIKit


@objc protocol DropDownDelegate: class {
   @objc optional func selectedDataFromDropDown(_ value: String?)
   @objc optional func selectedProductDataFromDropDown(_ value: String?, id: String?)
}



class DropdownView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableDropdown: UITableView!
    weak var delegate: DropDownDelegate?
    var arrData:Array = [Any]()


    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func initialSetupWithData(arrayData: [Any]){
        
        arrData.removeAll()
        
        arrData = arrayData
        print(arrData)
        
        tableDropdown.layer.borderColor = UIColor.black.cgColor
        tableDropdown.layer.borderWidth = 1.0
        
        tableDropdown.register(UINib(nibName: "DropdownTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DropdownTableViewCell")
        tableDropdown.dataSource = self
        tableDropdown.delegate = self
    }
    
    
    // MARK: - DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownTableViewCell") as! DropdownTableViewCell
        if let data = arrData [indexPath.row] as? NSDictionary {
            cell.lblValue.text = data["title"] as? String
        }else{
            cell.lblValue.text = arrData [indexPath.row] as? String
        }
        
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
        
    }
    
    
    
    
    // MARK: - Delegates
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableDropdown.deselectRow(at: indexPath, animated: false)
        if let data = arrData [indexPath.row] as? NSDictionary {
            //delegate?.selectedDataFromDropDown(data["title"] as? String)
            delegate?.selectedProductDataFromDropDown!(data["title"] as? String, id: data["id"] as? String)
            
            NSLog( (data["id"] as? String)!)
            
            UserDefaults.standard.set((data["id"] as? String)!, forKey: "selectedListingId") //setObject

        }else{
            delegate?.selectedDataFromDropDown!(arrData [indexPath.row] as? String)
        }
        
        
        self.removeFromSuperview()
        
    }

}
