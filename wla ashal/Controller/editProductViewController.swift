//
//  editProductViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/26/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class editProductViewController: SuperParentViewController ,UITableViewDataSource,UITableViewDelegate ,UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,ProtocolToSendData , UITextFieldDelegate{
    var productData = [String:Any]()
    var imageData = [Dictionary<String,Any>]()
    var product_id = ""
    
    var address = [addressMapProduct]()
    func setResultOfBusinessLogic(valueSent: addressMap) {
        self.myLocation = valueSent
        print(myLocation)
        self.addProductTableView.reloadData()
        
        
    }
    
    
    
    var categoryArray = [String]()
    var categoryIdArray = [String]()
    
    var subCategoryArray = [String: [String]]()
    var subCategoryIdArray = [String: [String]]()
    var cell_height = [CGFloat]()
    var myLocation:addressMap!
    var image = [String]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if image.count == 0 {
            return 4
        }
        return image.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let toViewController = segue.destination as? pickPlaceViewController {
            toViewController.delegate = self
        }
        
    }
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
     let yourWidth = CGFloat((self.view.frame.size.width / 3) - 10 )
     let yourHeight = yourWidth
     
     return CGSize(width: yourWidth, height: yourWidth)
     
     }
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImageCell", for: indexPath as IndexPath) as! addImageCollectionViewCell
        if image.count == 0 {
            cell.image.image = UIImage(named: "pic_profile")
        }else{
            cell.image.sd_setImage(with: URL(string: image[indexPath.row] as? String ?? ""), placeholderImage: UIImage(named: "pic_profile"))
            let tapImage = UITapGestureRecognizer(target:self,action:#selector(self.tapImage(_:)))
            cell.image.tag = indexPath.row
            tapImage.view?.tag = indexPath.row
            cell.image.isUserInteractionEnabled = true
           // cell.image.tapr
            cell.image.addGestureRecognizer(tapImage)
        }
        
        return cell
    }
    func tapImage(_ sender:UITapGestureRecognizer){
        self.image.remove(at: (sender.view?.tag)!)
        print(sender.view?.tag)
        self.addProductTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editProductCell") as? editProductTableViewCell
        
        cell?.titleText.text = productData["name"] as? String ?? ""
        cell?.bodyTextView.text = productData["body"] as? String ?? ""
        cell?.addressText.text = productData["address"] as? String ?? ""
        print(productData["address"])
        
        cell?.imageCollectionView.delegate = self
        cell?.imageCollectionView.dataSource = self
        let myColor = UIColor.clear
      
        cell?.saveBtn.ButtonborderRoundradius(radius: 10)
        cell?.parent = self
        cell?.imageCollectionView.reloadData()
        
        print(categoryArray)
        cell?.addressText.addTarget(self, action:#selector(self.textDidBeginEditing(sender:)), for: UIControlEvents.editingDidBegin)
        cell?.addressText.delegate = self
        if !categoryArray.isEmpty {
            cell?.mainCategory.anchorView = cell?.mainBtn // UIView or UIBarButtonItem
            cell?.mainCategory.dataSource = self.categoryArray
            if let category_id = productData["category_id"] as? String {
                cell?.mainBtn.setTitle(self.categoryArray[categoryIdArray.index(of: productData["category_id"] as? String ?? "0")!], for: .normal)
                cell?.category_id = self.categoryIdArray[categoryIdArray.index(of: productData["category_id"] as? String ?? "0")!]
                var selected_sub_id = subCategoryIdArray[productData["category_id"] as? String ?? "0"]!
                var selected_sub = subCategoryArray[productData["category_id"] as? String ?? "0"]!
                
                cell?.sub_id = selected_sub_id[selected_sub_id.index(of: productData["subcategory_id"] as? String ?? "0")!]
                cell?.subBtn.setTitle(selected_sub[selected_sub_id.index(of: productData["subcategory_id"] as? String ?? "0")!], for: .normal)
                
            }
            
            cell?.mainCategory.width = cell?.mainBtn.frame.size.width
            cell?.mainCategory.direction = .any
            cell?.mainCategory.bottomOffset = CGPoint(x: 0, y:(cell?.mainCategory.anchorView?.plainView.bounds.height)!)
           
            
            cell?.mainCategory.selectionAction = { [unowned self] (index_sub: Int, item: String) in
                print("Selected item: \(item) at index: \(index_sub)")
                cell?.mainBtn.setTitle("+\(self.categoryArray[index_sub])", for: .normal)
                self.view.layoutIfNeeded()
                cell?.category_id = "\(self.categoryIdArray[index_sub])"
                cell?.subBtn.isHidden = true
                // cell?.childrenTop.constant = 7
                
                if let children_exist = self.subCategoryIdArray[self.categoryIdArray[index_sub]] as? [String]{
                    if !(self.subCategoryIdArray[self.categoryIdArray[index_sub]]?.isEmpty)!{
                        // cell?.childrenTop.constant = 7
                        cell?.subBtn.isHidden = false
                        cell?.subCategory.anchorView = cell?.subBtn // UIView or UIBarButtonItem
                        cell?.subCategory.dataSource = self.subCategoryArray[self.categoryIdArray[index_sub]]!
                        cell?.subBtn.setTitle(self.subCategoryArray[self.categoryIdArray[index_sub]]?.first as? String ?? "", for: .normal)
                        cell?.sub_id = (self.subCategoryIdArray[self.categoryIdArray[index_sub]]?.first!)!
                        cell?.subCategory.width = cell?.subBtn.frame.size.width
                        cell?.subCategory.direction = .any
                        cell?.subCategory.bottomOffset = CGPoint(x: 0, y:(cell?.subCategory.anchorView?.plainView.bounds.height)!)
                        cell?.subCategory.selectionAction = { [unowned self] (index: Int, item: String) in
                            print("Selected item: \(item) at index: \(index)")
                            cell?.subBtn.setTitle("+\(self.subCategoryArray[self.categoryIdArray[index_sub]]![index])", for: .normal)
                            self.view.layoutIfNeeded()
                            cell?.sub_id = "\(self.subCategoryIdArray[self.categoryIdArray[index_sub]]![index])"
                            //append child dropdown
                        }
                    }
                }else{
                    
                    //  self.productTableView.reloadData()
                }
                
                //append child dropdown
                
            }
        }
        
        
        self.addProductTableView.setNeedsLayout()
        self.addProductTableView.layoutIfNeeded()
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 625
    }
    func textDidBeginEditing(sender:UITextField) -> Void
    {
        let pickup = self.storyboard?.instantiateViewController(withIdentifier: "pickPlaceView") as? pickPlaceViewController
        pickup?.delegate = self
        self.navigationController?.pushViewController(pickup!, animated: true)
        // handle begin editing event
    }
    
    @IBOutlet weak var addProductTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCategory()
        myLocation = addressMap(longtide: 0.0, latitude: 0.0, address: "", city: "")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        print(myLocation)
        self.navigationItem.title = "اضافة خدمة او اعلان"
        get_product()
    }
    func getAllCategory(){
        let parameters = [String:AnyObject]()
        var all_url = base_url + "all_category"
        Alamofire.request(all_url, method: .post ,parameters:parameters).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                print(value)
                print("value")
                
                if let results = response.result.value as? Dictionary<String,Any>{
                    print(results)
                    
                    if let categ = results["categories"] as? [[String:AnyObject]]{
                        for categories:[String:AnyObject] in categ {
                            
                            self.categoryArray.append(categories["name"] as? String ?? "")
                            self.categoryIdArray.append(categories["id"] as? String ?? "")
                            print("categoryArray\(self.categoryArray)")
                            
                            if let subcategories = categories["subcategories"] as? [[String:AnyObject]]{
                                var each_sub_name =  [String]()
                                var each_sub_id =  [String]()
                                for subcategory:[String:AnyObject] in subcategories {
                                    each_sub_name.append(subcategory["name"] as? String ?? "")
                                    each_sub_id.append(subcategory["id"] as? String ?? "")
                                    
                                }
                                self.subCategoryArray[categories["id"] as? String ?? "0"] = each_sub_name
                                self.subCategoryIdArray[categories["id"] as? String ?? "0"] = each_sub_id
                                
                                
                            }else{
                                self.cell_height.append(50)
                            }
                            
                        }
                    }
                    self.addProductTableView.reloadData()
                }
                
            case .failure(let error):
                break;
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    func get_product (){
        productData.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String: Any]()
        parameters["id"] = product_id
        if checkUserData() {
            parameters["user_id"] = userData["id"]
        }
        print(parameters)
        let cart_url = base_url + "get_product"
        Alamofire.request(cart_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        if let product_data = results["product"] as? [String:AnyObject] {
                            print(product_data)
                            self.productData = product_data
                            self.imageData.removeAll()
                            self.navigationItem.title = self.productData["name"] as? String ?? ""
                            for str in (product_data["images"] as? NSArray)! {
                                print(str)
                                var each_list = [String:AnyObject]()
                                var url_image = str as?  String ?? ""
                                if url_image != ""{
                                    
                                    var base_url  = results["base_url"] as?  String ?? ""
                                    url_image = "\(base_url)\(str)"
                                    print(url_image)
                                    
                                }else{
                                    url_image  = ""
                                }
                                
                                self.image.append(url_image.replacingOccurrences(of: " ", with: "%20") as String)
                                print(self.image)
                                
                                
                            }
                            
                            self.addProductTableView.reloadData()
                        }
                        self.addProductTableView.reloadData()
                    }
                }
            }
            
        }
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

