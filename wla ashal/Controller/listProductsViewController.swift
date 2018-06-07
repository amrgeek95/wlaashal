//
//  listProductsViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/23/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
import SDWebImage
import FloatRatingView
class listProductsViewController: SuperParentViewController  ,UICollectionViewDelegate , UICollectionViewDataSource ,FloatRatingViewDelegate{
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
    }
    
    var products = [Dictionary<String,Any>]()
    var category_id = ""
    var address_cordinate = [addressMapProduct]()
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var mapBtn: UIButton!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return  self.products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listProductCell", for: indexPath) as? listProductCollectionViewCell
       cell?.iconImg.sd_setImage(with: URL(string: products[indexPath.row]["image"] as? String ?? "" ), placeholderImage: UIImage(named: "car_d"))
        cell?.nameLabel.text = products[indexPath.row]["name"] as? String ?? ""
        cell?.containerView.ViewborderRound(border: 1, corner: 15)
        cell?.iconImg.ImageBorderRadius(border: 0.5, corner: 15)
        cell?.id = products[indexPath.row]["id"] as? String ?? ""
        cell?.userReview.delegate = self
        cell?.userReview.backgroundColor = UIColor.clear
        cell?.userReview.tag = 0
        cell?.userReview.contentMode = UIViewContentMode.scaleAspectFit
        
        cell?.userReview.maxRating = 5
        cell?.userReview.minRating = 1
       
        cell?.userReview.editable = false
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showProduct = self.storyboard?.instantiateViewController(withIdentifier: "productView") as? productViewController
        showProduct?.product_id = products[indexPath.row]["id"] as? String ?? ""
        self.navigationController?.pushViewController(showProduct!, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = CGFloat((self.view.frame.size.width / 2)  )
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourWidth)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        get_products()
        // Do any additional setup after loading the view.
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = self
        self.navigationItem.title = "الاعلانات"
    }
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func categoryAction(_ sender: Any) {
    }
    
    @IBAction func mapAction(_ sender: Any) {
        let showMapList = self.storyboard?.instantiateViewController(withIdentifier: "mapListView") as? mapListViewController
        showMapList?.addressFrom = address_cordinate
        self.navigationController?.pushViewController(showMapList!, animated: true)
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
extension listProductsViewController {
    func get_products(){
        self.products.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:Any]()
        var url = base_url + "get_products"
        if my_products == 1 {
            if checkUserData(){
                
                parameters["user_id"] = userData["id"] as Any
            }
        } else if  filter_category == 1 {
           
        }
        else if  my_favourites == 1 {
            url = base_url + "my_favourites"
            parameters["user_id"] = userData["id"] as Any
        }
        if advanced_flag == true {
            if subcategory_id != "" {
                parameters["subcategory_id"] = subcategory_id as Any
            }
            if secondary_id != "" {
                parameters["secondary_id"] = secondary_id as Any
            }
        }
         parameters["category_id"] = category_id as Any
        
        
        print(parameters)
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            (response) in
            MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:Any]{
                print(results)
                
                advanced_flag = false
                if  let result = results["products"] as? [[String:Any]] {
                    print(result)
                    for str:[String:Any] in result {
                        print(str)
                        
                        var each_list = [String:Any]()
                        if str["latitude"]! as? Double != 0  {
                            print(Double(str["longtide"] as? String ?? "0")! )
                            
                            let newAddress = addressMapProduct(longtide: Double(str["longtide"] as? String ?? "0")! , latitude: Double(str["latitude"] as? String ?? "0")!, address: str["address"] as? String ?? "", city: str["city"] as? String ?? "", productName: str["name"] as? String ?? "", productID: str["id"] as? String ?? "")
                            print(newAddress)
                            
                            self.address_cordinate.append(newAddress)
                        }
                        print(self.address_cordinate)
                        
                        each_list["name"] =  str["name"]! as Any
                        each_list["id"] =  str["id"] as Any
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as Any
                        each_list["date"] =  str["date"] as Any
                        each_list["city"] =  str["city"] as Any
                        each_list["category"] =  str["category"] as Any
                        each_list["user"] =  str["user"] as Any
                        self.products.append(each_list)
                        
                        
                        print(self.products)
                    }
                    self.listCollectionView.reloadData()
                }
            }
        }
    }
}
