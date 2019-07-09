//
//  ProductImageViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 12/02/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import SDWebImage

class ProductImageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {

    @IBOutlet weak var productImageCollectionView: UICollectionView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var scrollProduct: UIScrollView!
    var imageProduct:UIImageView = UIImageView()
    var productDetails = ProductObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollProduct.minimumZoomScale = 0.8
        scrollProduct.maximumZoomScale = 3.0
        scrollProduct.zoomScale = 1.0
        scrollProduct.delegate = self
        setCollectionViewDelegates()
        productImageCollectionView.reloadData()
        
        imageProduct.frame = CGRect(x: 10, y: 10, width: scrollProduct.bounds.width - 20,  height : scrollProduct.bounds.height - 20)
        scrollProduct.addSubview(imageProduct)
        self.imageProduct.sd_setShowActivityIndicatorView(true)
        if self.productDetails.pArrImages.count > 0 {
            let imgDic = self.productDetails.pArrImages[0]
            let imgPath = APPURL.ImagePath + (imgDic["image"] as? String)!
            self.imageProduct.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named:""), options: .cacheMemoryOnly)
            self.imageProduct.contentMode = .scaleAspectFit
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageProduct
    }
    // MARK: - Size Collection View
    func setCollectionViewDelegates(){
        
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        // let newView:NewSectionHeaderView = .fromNib()
        productImageCollectionView.register(nib, forCellWithReuseIdentifier: "kProductCollectionViewCell")
        
        productImageCollectionView.delegate = self
        productImageCollectionView.dataSource = self
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
        self.imageProduct.image = cell.imgvProduct.image
        scrollProduct.setZoomScale(1.0, animated: true)
    }

}
