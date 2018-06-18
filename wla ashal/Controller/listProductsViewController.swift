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
import CoreLocation
class listProductsViewController: SuperParentViewController  ,UICollectionViewDelegate , UICollectionViewDataSource ,FloatRatingViewDelegate ,PopUpPickerViewDelegate ,CLLocationManagerDelegate{
    @IBOutlet weak var listPickerView: UIPickerView!
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
    }
    
    var products = [Dictionary<String,Any>]()
    var category_id = ""
    var address_cordinate = [addressMapProduct]()
    var sub_id = ""
    var nearestAddress : addressMap!
    var searchText = ""
    var searchFlag = false
     let locationManager = CLLocationManager()
    
    var nearestBool = false
    var product_ids = [String]()
    var sortDirection = 0
    var sortProduct = false
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var mapBtn: UIButton!

    var list = [String]()
     var list_id = [String]()

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
      //  self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        sub_id = self.list_id[row]
       get_products(sub: true)
    }
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
        cell?.userReview.rating = Float(products[indexPath.row]["rate"] as? String ?? "0")!
       
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
     var picker: PopUpPickerView!
    var sampleTextField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        get_products()
        locationManager.delegate = self
        nearestAddress = addressMap(longtide: 0.0, latitude: 0.0, address: "", city: "")
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        picker = PopUpPickerView()
      
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(picker)
        } else {
            self.view.addSubview(picker)
        }
      
        // Do any additional setup after loading the view.
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = self
        self.navigationItem.title = "الاعلانات"
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft
        listCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        self.navigationItem.title = "الاعلانات"
        get_subcategories()
    }
    func donePicker (sender:UIPickerView){
        
    }
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nearestAction(_ sender: Any) {
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            print(locationManager)
            nearestAddress.longtide = (locationManager.location?.coordinate.longitude)!
           nearestAddress.latitude = (locationManager.location?.coordinate.latitude)!
            nearestBool = true
            get_products()
           }else{
            let alertController = UIAlertController(title: NSLocalizedString("تنبية", comment: ""), message: NSLocalizedString("يجب السماح بتحديد المكان", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("الغاء", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("الاعدادات", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
            }
            
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    @IBAction func categoryAction(_ sender: Any) {
    }
    @IBAction func bestRateAction(_ sender: UIButton) {
        print(product_ids)
         var newproducts = [Dictionary<String,Any>]()
        if sortDirection == 0 {
            sortDirection = 1
            sender.setTitle("الاقدم", for: .normal)
        }else{
         sortDirection = 0
            sender.setTitle("الاحدث", for: .normal)
        }
        sortProduct = true
        get_products()
        
    }
    @IBAction func showSubAction(_ sender: Any) {
         //self.pickUp(sampleTextField)
        picker.showPicker()

    }
    func appMovedToForeground() {
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            nearestAddress.longtide = (locationManager.location?.coordinate.longitude)!
            nearestAddress.latitude = (locationManager.location?.coordinate.latitude)!
            
            
            
        }
        print("App moved to ForeGround!")
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
    func get_subcategories(){
        self.list.removeAll()
        self.list_id.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
        parameters["category_id"] = category_id as AnyObject
     
        var url = base_url + "get_subcategory"
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            (response) in
            MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                
                if  let result = results["subcategories"] as? [[String:String]] {
                    print(result)
                    for str:[String:String] in result {
                        print(str)
                        self.list.append(str["name"] as? String ?? "")
                          self.list_id.append(str["id"] as? String ?? "")
                    }
                 self.picker.reloadInputViews()
                    self.picker.delegate = self
                }
            }
        }
    }
    func get_products(sub:Bool = false){
        self.products.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:Any]()
        var url = base_url + "get_products"
        if my_products == 1 {
            if checkUserData(){
                
                parameters["user_id"] = userData["id"] as Any
            }
        } else if  searchFlag == true {
            parameters["search"] = searchText as Any
        }
        else if  my_favourites == 1 {
            url = base_url + "my_favourites"
            parameters["user_id"] = userData["id"] as Any
        }
        if sub == true {
            if sub_id != "" {
           parameters["subcategory_id"] = sub_id as Any
        }
        }
        if nearestBool == true {
            parameters["long"] = nearestAddress.longtide
            parameters["lat"] = nearestAddress.latitude
        }
        if sortProduct == true {
           parameters["sort"] = sortDirection
        }
        nearestBool = false
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
                        self.product_ids.append(str["id"] as? String ?? "0")
                        each_list["name"] =  str["name"]! as Any
                        each_list["id"] =  str["id"] as Any
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as Any
                        each_list["date"] =  str["date"] as Any
                        each_list["city"] =  str["city"] as Any
                        each_list["category"] =  str["category"] as Any
                        each_list["user"] =  str["user"] as Any
                        each_list["rate"] =  str["rate"]
                        self.products.append(each_list)
                        
                        
                        print(self.products)
                    }
                    self.listCollectionView.reloadData()
                }
            }
        }
    }
}
