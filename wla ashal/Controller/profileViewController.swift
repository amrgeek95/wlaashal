//
//  profileViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
import FloatRatingView
class profileViewController: SuperParentViewController , UITableViewDelegate , UITableViewDataSource ,UICollectionViewDelegate , UICollectionViewDataSource , FloatRatingViewDelegate{
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
    }
    
    var products = [Dictionary<String,AnyObject>]()
    var otherUser = [String:AnyObject]()
    var user_id = ""
    var ads_count = ""
    var mySelf  = false
    @IBOutlet weak var profileTableView: UITableView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileImageCollectionCell", for: indexPath) as? profileImageCollectionViewCell
        cell?.image.sd_setImage(with: URL(string: products[indexPath.row]["image"] as? String ?? "" ), placeholderImage: UIImage(named: "car_d"))
        
        cell?.titleLabel.text = products[indexPath.row]["name"] as? String ?? ""
        cell?.containerView.ViewborderRound(border: 1, corner: 15)
        cell?.containerView.dropShadow(color: UIColor.gray, opacity: 0.7, radius: 5)
      //  cell?.contentView.dropShadow(color: UIColor.gray, radius: 10)
      //  cell?.contentView.ViewborderRound(border: 0.5, corner: 10)
      
        if mySelf == false {
            cell?.deleteBtn.isHidden = true
            cell?.editBtn.isHidden = true
             cell?.userReview.isHidden = false
        }else{
            cell?.deleteBtn.isHidden = false
            cell?.editBtn.isHidden = false
            print(products[indexPath.row]["id"] as? Int ?? 0)
             cell?.userReview.isHidden = true
            
            cell?.deleteBtn.tag = indexPath.row
            cell?.deleteBtn.addTarget(nil, action: #selector(self.delete_product(sender:)), for: .touchUpInside)
        }
        
        cell?.id = products[indexPath.row]["id"] as? String ?? ""
        
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
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        get_userData()
        get_products()
        
        if user_id != "" {
            if userData["id"] as? String == otherUser["id"] as? String{
                mySelf =  true
            }else{
                mySelf =  false
            }
        }else{
            mySelf =  true
        }
    }
    @IBOutlet weak var adsNumber: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 215
        }else {
            return 400
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topProfileCell") as! topProfileTableViewCell
            cell.pointsNumber.setTitle(otherUser["points"] as? String ?? "", for: .normal)
            cell.adsBtn.setTitle(ads_count as? String ?? "", for: .normal)
            //   cell.pointsNumber.setTitle(otherUser["points"], for: .normal)
            let userImg = otherUser["image"] as? String ?? ""
            cell.userImage.sd_setImage(with: URL(string: image_url + userImg), placeholderImage: UIImage(named: "Asset 9"))
            cell.userImage.ImageBorderCircle()
            cell.codeBtn.setTitle("الكود الترويجي\n \(123456)", for: .normal)
            cell.codeLabel.text = otherUser["code"] as? String ?? ""
            cell.codeView.ViewborderRound(border: 0.5, corner: 10)
           
            if mySelf == false {
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showChat(_:)))
                cell.chatImage.isUserInteractionEnabled = true
                cell.chatImage.addGestureRecognizer(tapGesture)
                
                let mobileGesture = UITapGestureRecognizer(target: self, action: #selector(self.pressCall(_:)))
                cell.callImg.isUserInteractionEnabled = true
                cell.callImg.addGestureRecognizer(mobileGesture)
                
                cell.pointsNumber.addTarget(self, action: #selector(self.follow_user(sender:)), for: .touchUpInside)
                
                cell.pointsNumber.setTitle("", for: .normal)
                
                cell.pointsNumber.setBackgroundImage(nil, for: .normal)
                cell.pointsNumber.setImage(UIImage(named:"follow"), for: .normal)
                cell.codeBtn.addTarget(nil, action: #selector(self.addReview(sender:)), for: .touchUpInside)
                cell.codeBtn.setTitle("تقييم", for: .normal)
                cell.userReview.rating = otherUser["rate"] as? Float ?? 5
                cell.codeViewHeightConstraint.constant = 30
                
                cell.codeLabel.text = ""
                 cell.userReview.isHidden = false
                cell.pointLabel.text = "متابعة"
                cell.codeBtn.isHidden = false
            }else{
                cell.callImg.isHidden = true
                cell.chatImage.isHidden = true
                cell.pointsNumber.removeTarget(self, action: #selector(self.follow_user(sender:)), for: .touchUpInside)
                cell.pointsNumber.setBackgroundImage(UIImage(named:"Hexa"), for: .normal)
                cell.pointsNumber.setImage(nil, for: .normal)
                cell.pointsNumber.setTitle("0", for: .normal)
                cell.pointLabel.text = "عدد النقاط"
                 cell.userReview.isHidden = true
               
                cell.userReview.rating = userData["rate"] as? Float ?? 5
                 cell.codeViewHeightConstraint.constant = 50
            }
            cell.parent = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileImageCell") as! profileImageTableViewCell
            cell.parent = self
            cell.imageCollectionView.delegate = self
            cell.imageCollectionView.dataSource = self

            return cell
        }
        
    }
    func addReview(sender:UIButton){
        self.performSegue(withIdentifier: "showAddReview", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toViewController = segue.destination as? addReviewViewController {
            toViewController.user_id = otherUser["id"] as? String ?? ""
        }
    }
    func showChat(_ sender:UITapGestureRecognizer) {
        let showChat = self.storyboard?.instantiateViewController(withIdentifier: "parentChatView") as? parentChatViewController
        showChat?.chat_id =  "0"
        showChat?.otherId = self.otherUser["id"] as? String ?? ""
        showChat?.otherName = self.otherUser["name"] as? String ?? ""
        if checkUserData() {
            if self.otherUser["id"] as? String == userData["id"] as? String {
                wla_ashal.toastView(messsage: "لا يمكن ان تراسل نفسك", view: self.view)
            }else{
                self.navigationController?.pushViewController(showChat!, animated: true)
            }
        }else{
            wla_ashal.toastView(messsage: "يجب تسجيل الدخول اولا", view: self.view)
        }
        
        
    }
   
    func pressCall(_ sender: UITapGestureRecognizer) {
        do {
            print(otherUser["mobile"])
            let phoneNum = otherUser["mobile"] as? String ?? ""
            if phoneNum !=  " " {
                phoneNum.makeACall()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func follow_user(sender:UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String: Any]()
         parameters["user_id"] = userData["id"]
         parameters["to_id"] = user_id
        print(parameters)
        let cart_url = base_url + "follow"
        Alamofire.request(cart_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                         self.profileTableView.reloadData()
                        wla_ashal.toastView(messsage: results["message"] as? String ?? "", view: self.view)
                    }
                }
            }
            
        }
    }
    func delete_product(sender:UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String: Any]()
        parameters["user_id"] = userData["id"]
        parameters["id"] = self.products[sender.tag]["id"]
        print(parameters)
        let cart_url = base_url + "delete_product"
        Alamofire.request(cart_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                       self.products.remove(at: sender.tag)
                        self.profileTableView.reloadData()
                    }
                }
            }
            
        }
    }
    func get_userData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String: Any]()
        if user_id != "" {
            
            parameters["id"] = user_id
        }else{
            parameters["id"] = userData["id"]
        }
        print(parameters)
        let cart_url = base_url + "get_user"
        Alamofire.request(cart_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        
                        
                        if let user_data = results["user"] as? [String:AnyObject] {
                            self.otherUser = user_data
                            if userData["id"] as? String == self.otherUser["id"] as? String{
                                self.mySelf =  true
                            }else{
                                self.mySelf =  false
                            }
                            if self.user_id != "" {
                                self.navigationItem.title = self.otherUser["name"] as? String ?? ""
                            }else{
                                self.navigationItem.title = "الملف الشخصي"
                            }
                            self.profileTableView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
    func get_products(){
        self.products.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:Any]()
        var url = base_url + "get_products"
        if user_id != "" {
            
            parameters["user_id"] = user_id
        }else{
            parameters["user_id"] = userData["id"]
        }
        
        print(parameters)
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            (response) in
            MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                
                advanced_flag = false
                if  let result = results["products"] as? [[String:AnyObject]] {
                    print(result)
                    self.ads_count = "\(result.count)"
                    for str:[String:AnyObject] in result {
                        print(str)
                        
                        var each_list = [String:AnyObject]()
                        
                        each_list["name"] =  str["name"]! as AnyObject
                        each_list["id"] =  str["id"] as AnyObject
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                        each_list["date"] =  str["date"] as AnyObject
                        each_list["city"] =  str["city"] as AnyObject
                        each_list["category"] =  str["category"] as AnyObject
                        each_list["user"] =  str["user"] as AnyObject
                        self.products.append(each_list)
                        
                        
                        print(self.products)
                    }
                    self.profileTableView.reloadData()
                }
            }
        }
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
