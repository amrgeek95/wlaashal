//
//  productViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/23/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
import ImageSlideshow
import Lightbox


class productViewController: SuperParentViewController , UITableViewDelegate , UITableViewDataSource{

    
    var productData = [String:Any]()
    var imageData = [Dictionary<String,Any>]()
    var product_id = ""
    var address = [addressMapProduct]()
    
    @IBOutlet weak var productTableView: UITableView!
    var imagelightbox = [LightboxImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
get_product()
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.title = "تفاصيل الاعلان"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        else if indexPath.row == 1 {
            return UITableViewAutomaticDimension
            
        }else{
            return 200
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
         let cell = tableView.dequeueReusableCell(withIdentifier: "productSliderCell") as! productSliderTableViewCell
            cell.imageSlideShow.backgroundColor = UIColor.white
            cell.imageSlideShow.slideshowInterval = 5.0
            cell.imageSlideShow.pageControlPosition = PageControlPosition.insideScrollView
            cell.imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
            cell.imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.green
            cell.imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
            
            cell.imageSlideShow.currentPageChanged = { page in
                print("current page:", page)
            }
            if imageData.count > 0 {
                
                
                let arr =  imageData.map { AlamofireSource(urlString: (($0["image"] as AnyObject).replacingOccurrences(of: " ", with: "&") as? String)!)!
                    
                }
            
                print(arr)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.imageSlideShow.setImageInputs(arr)
            }
            for imageLight in imageData {
                if imageLight["image"] as! String != "" {
                    if imagelightbox.count != imageData.count {
                        imagelightbox.append(LightboxImage(imageURL: URL(string: imageLight["image"] as! String)!))
                        let tapImg = UITapGestureRecognizer(target:self,action: #selector(self.tapImg(_:)))
                    cell.imageSlideShow.addGestureRecognizer(tapImg)
                        
                    }
                }
            }
           
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell") as? productDetailTableViewCell
            cell?.titleLabel.text = productData["name"] as? String ?? ""
            cell?.categoryLabel.text = productData["category_name"] as? String ?? ""
            cell?.bodyLabel.text = productData["body"] as? String ?? ""
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "productBottomCell") as? productBottomTableViewCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showUser(sender:)))
            cell?.userImg.isUserInteractionEnabled = true
            cell?.userImg.addGestureRecognizer(tapGesture)
            
            let mobileGesture = UITapGestureRecognizer(target: self, action: #selector(self.pressCall(_:)))
            cell?.phoneImg.isUserInteractionEnabled = true
            cell?.phoneImg.addGestureRecognizer(mobileGesture)
        
            let chatGesture = UITapGestureRecognizer(target: self, action: #selector(self.openChat(_:)))
            cell?.chatIcon.isUserInteractionEnabled = true
            cell?.chatIcon.addGestureRecognizer(chatGesture)
            
            let mapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openMap(_:)))
            cell?.locationImg.isUserInteractionEnabled = true
            cell?.locationImg.addGestureRecognizer(mapGesture)
            return cell!
        }
    }
    func openMap (_ sender:UITapGestureRecognizer) {
        let showMap = self.storyboard?.instantiateViewController(withIdentifier: "mapListView") as? mapListViewController
        showMap?.addressFrom = address
        showMap?.request = true
        print(address)
        self.navigationController?.pushViewController(showMap!, animated: true)
    }
    func openChat(_ sender:UITapGestureRecognizer) {
        let showChat = self.storyboard?.instantiateViewController(withIdentifier: "parentChatView") as? parentChatViewController
        showChat?.chat_id =  "0"
        showChat?.otherId = self.productData["user_id"] as? String ?? ""
        showChat?.otherName = self.productData["user"] as? String ?? ""
        if checkUserData() {
            if self.productData["user_id"] as? String == userData["id"] as? String {
                wla_ashal.toastView(messsage: "لا يمكن ان تراسل نفسك", view: self.view)
            }else{
                self.navigationController?.pushViewController(showChat!, animated: true)
            }
        }else{
            wla_ashal.toastView(messsage: "يجب تسجيل الدخول اولا", view: self.view)
        }
        
        
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
        self.productTableView.reloadData()
    }
    func tapImg(_ sender:UITapGestureRecognizer){
        let controller = LightboxController(images: imagelightbox)
        
        //  controller.dynamicBackground = true
        
        LightboxConfig.CloseButton.text = "اغلاق"
        present(controller, animated: true, completion: nil)
    }
    func showUser(sender:UITapGestureRecognizer){
        let profileUser = self.storyboard?.instantiateViewController(withIdentifier: "profileView") as? profileViewController
        profileUser?.user_id = productData["user_id"] as? String ?? ""
        print(productData["user_id"] as? String ?? "")
        
        self.navigationController?.pushViewController(profileUser!, animated: true)
    }
    func pressCall(_ sender: UITapGestureRecognizer) {
        do {
            print(productData["mobile"])
            let phoneNum = productData["mobile"] as? String ?? ""
            if phoneNum !=  " " {
                phoneNum.makeACall()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func get_product (){
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
                            let newAddress = addressMapProduct(longtide: Double(product_data["longtide"] as? String ?? "0")! , latitude: Double(product_data["latitude"] as? String ?? "0")!, address: product_data["address"] as? String ?? "" , city: product_data["city"] as? String ?? "", productName:self.productData["name"] as? String ?? "", productID: self.productData["id"] as? String ?? "")
                            print(newAddress)
                            
                            self.address.append(newAddress)
                            self.productData = product_data
                            self.imageData.removeAll()
                            self.navigationItem.title = "تفاصيل الاعلان"
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
                                
                                each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                                self.imageData.append(each_list)
                                
                            }
                            
                           self.productTableView.reloadData()
                        }
                        self.productTableView.reloadData()
                    }
                }
            }
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
       
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
