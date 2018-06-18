//
//  requestViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
class requestViewController: SuperParentViewController , UITableViewDelegate , UITableViewDataSource {
    var headerData = ["first":"تفاصيل الطلب","first_image":"icon_1","second":"تفاصيل صاحب الطلب","second_image":"user_c"]
    var requestData =   [[String:Any]]()
    var user_request = [String:AnyObject]()
    var type = ""
    var id = ""
    var myself = false
    var accepted = false
    var address = [addressMapProduct]()
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 40
            }else{
                return UITableViewAutomaticDimension
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 40
            }else{
                return UITableViewAutomaticDimension
            }
        }else{
            return 90
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if requestData.isEmpty {
            return 0
        }else{
            if section == 0 {
                return 4
            }
          
            else if section <= 2{
                
                if myself == true {
                    if accepted == false {
                        return 0
                    }
                }
                if section == 1 {
                    return 2
                }
                return 1
            }
                
            else {
                if accepted == true ||  myself == true {
                    
                    return 0
                }else{
                 
                    return 1
                }
            }
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "requestHeaderCell") as! requestHeaderTableViewCell
                cell.titleLabel.text = headerData["first"] as? String ?? ""
                
                cell.mainImage.image = UIImage(named:headerData["first_image"]!)
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "requestBodyCell") as! requestBodyTableViewCell
                print(requestData[indexPath.row - 1]["title"] as? String ?? "")
                
                cell.titleLabel.text = requestData[indexPath.row - 1]["title"] as? String ?? ""
                cell.bodyLabel.text = requestData[indexPath.row - 1]["body"] as? String ?? ""
                cell.mainImage.image = UIImage(named:requestData[indexPath.row - 1]["image"] as? String ?? "")
                let tapGesture = UITapGestureRecognizer(target:nil,action:#selector(self.showMap(sender:)))
                cell.mapImage.isUserInteractionEnabled  = true
                cell.mapImage.addGestureRecognizer(tapGesture)
                cell.titleLabel.isUserInteractionEnabled = true
                cell.titleLabel.addGestureRecognizer(tapGesture)
                if requestData[indexPath.row - 1]["map"]as? Bool == true {
                    cell.mapImage.isHidden = false
                    
                }else{
                    cell.mapImage.isHidden = true
                }
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "requestHeaderCell") as! requestHeaderTableViewCell
                cell.titleLabel.text = headerData["second"] as? String ?? ""
                
                cell.mainImage.image = UIImage(named:headerData["second_image"]!)
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "requestBodyCell") as! requestBodyTableViewCell
                cell.titleLabel.text = user_request["title"] as? String ?? ""
                cell.bodyLabel.text = user_request["body"] as? String ?? ""
                cell.mainImage.image = UIImage(named:user_request["image"] as? String ?? "")
                cell.mapImage.isHidden = true
                return cell
            }
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "requestBottomCell") as? requestBottomTableViewCell
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showUser(sender:)))
            cell?.userImage.isUserInteractionEnabled = true
            cell?.userImage.addGestureRecognizer(tapGesture)
            
            let mobileGesture = UITapGestureRecognizer(target: self, action: #selector(self.pressCall(_:)))
            cell?.mobileImage.isUserInteractionEnabled = true
            cell?.mobileImage.addGestureRecognizer(mobileGesture)
            
            let chatGesture = UITapGestureRecognizer(target: self, action: #selector(self.openChat(_:)))
            cell?.commentImage.isUserInteractionEnabled = true
            cell?.commentImage.addGestureRecognizer(chatGesture)
            
            return cell!
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionRequestCell") as! actionRequestTableViewCell
            cell.acceptAction.ButtonborderRoundradius(radius: 7)
            cell.rejectBtn.ButtonborderRoundradius(radius: 7)
            cell.acceptAction.addTarget(nil, action: #selector(self.accept(sender:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row != 0 {
                if requestData[indexPath.row - 1]["map"]as? Bool == true {
                    let showMap = self.storyboard?.instantiateViewController(withIdentifier: "mapListView") as? mapListViewController
                    showMap?.addressFrom = address
                    showMap?.request = true
                    print(address)
                    self.navigationController?.pushViewController(showMap!, animated: true)
                }
            }
        }
        
        
        
    }
    func showMap (sender: UITapGestureRecognizer){
        let showMap = self.storyboard?.instantiateViewController(withIdentifier: "mapListView") as? mapListViewController
        showMap?.addressFrom = address
        showMap?.request = true
        print(address)
        
        self.navigationController?.pushViewController(showMap!, animated: true)
    }
    
    
    func openChat(_ sender:UITapGestureRecognizer) {
        let showChat = self.storyboard?.instantiateViewController(withIdentifier: "parentChatView") as? parentChatViewController
        showChat?.chat_id =  "0"
        showChat?.otherId = self.user_request["user_id"] as? String ?? ""
        showChat?.otherName = self.user_request["user"] as? String ?? ""
        if checkUserData() {
            if self.user_request["user_id"] as? String == userData["id"] as? String {
                wla_ashal.toastView(messsage: "لا يمكن ان تراسل نفسك", view: self.view)
            }else{
                self.navigationController?.pushViewController(showChat!, animated: true)
            }
        }else{
            wla_ashal.toastView(messsage: "يجب تسجيل الدخول اولا", view: self.view)
        }
        
        
    }
    func showUser(sender:UITapGestureRecognizer){
        let profileUser = self.storyboard?.instantiateViewController(withIdentifier: "profileView") as? profileViewController
        profileUser?.user_id = self.user_request["id"] as? String ?? ""
        print(user_request["id"] as? String ?? "")
        
        self.navigationController?.pushViewController(profileUser!, animated: true)
    }
    func pressCall(_ sender: UITapGestureRecognizer) {
        do {
            print(user_request["mobile"])
            let phoneNum = user_request["mobile"] as? String ?? ""
            if phoneNum !=  " " {
                phoneNum.makeACall()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    @IBOutlet weak var requestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "تفاصيل الطلب"
        get_request()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reject(sender:UIButton){
        
    }
    
    func accept(sender:UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String: Any]()
        parameters["id"] = id
        parameters["user_id"] = userData["id"]
        var cart_url = base_url + "accept_taxi"
        
        if type == "delivery" {
            cart_url = base_url + "accept_delivery"
        }
        print(parameters)
        Alamofire.request(cart_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        
                        let alert = UIAlertController(title: results["message"] as? String ?? "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler:{ (alert: UIAlertAction!) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                        ))
                        self.present(alert, animated: true, completion: nil)
                       
                       
                    }
                }
            }
            
        }
    }
    
    func get_request(){
         self.address.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String: Any]()
        parameters["id"] = id
        var cart_url = base_url + "get_taxi_request"
        
        if type == "delivery" {
            cart_url = base_url + "get_delivery_request"
        }
        print(parameters)
        Alamofire.request(cart_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        if let request_data = results["request"] as? [String:AnyObject] {
                            var message = ""
                            if self.type == "delivery" {
                                
                                message = "\(request_data["title"]!)"
                                self.requestData.append(["map":false,"image":"fire" ,"body":message as AnyObject,"title":"الشئ المراد توصيلة "])
                                message = "\(request_data["city"] as? String ?? "") \(request_data["address"] as? String ?? "")"
                                self.requestData.append(["map":true,"image":"map_gray" ,"body":"مكان العميل" as AnyObject,"title":"مكان الوصول"])
                                
                                let newAddress = addressMapProduct(longtide: Double(request_data["longtiude"] as? String ?? "0")! , latitude: Double(request_data["lat"] as? String ?? "0")!, address: message, city: request_data["city"] as? String ?? "", productName: "مكان العميل", productID: "")
                                print(newAddress)
                                
                                self.address.append(newAddress)
                            }else{
                                
                                message = "\(request_data["city_from"] as? String ?? "") \(request_data["address_from"] as? String ?? "")"
                                self.requestData.append(["map":true,"image":"map_gray" ,"body":"مكان العميل" as AnyObject,"title":"مكان العميل"])
                                let addressFrom = addressMapProduct(longtide: Double(request_data["long_from"] as? String ?? "0")! , latitude: Double(request_data["lat_from"] as? String ?? "0")!, address: message, city: request_data["city_from"] as? String ?? "", productName:"مكان العميل",productID:"")
                                message = "\(request_data["city_to"] as? String ?? "") \(request_data["address_to"] as? String ?? "")"
                                self.requestData.append(["map":true,"image":"map_gray" ,"body":"مكان الوصول" as AnyObject,"title":"مكان الوصول"])
                                
                                
                                let addressTo = addressMapProduct(longtide: Double(request_data["long_to"] as? String ?? "0")! , latitude: Double(request_data["lat_to"] as? String ?? "0")!, address: message, city: request_data["city_to"] as? String ?? "", productName:"مكان الوصول",productID:"")
                                
                                print(addressTo)
                                print(addressFrom)
                                
                                self.address.append(addressFrom)
                                self.address.append(addressTo)
                            }
                            
                            
                            message = "\(request_data["price"] as? String ?? "") ريال"
                            self.requestData.append(["map":false,"image":"doller_m" as AnyObject,"body":message as AnyObject,"title":"تكلفة الطلب" as AnyObject])
                            
                        }
                        if let userid =  results["request"]!["user_id"] as? String {
                            print( userData["id"] as? String )
                            print(userid)
                            
                            if userData["id"] as? String == userid {
                                self.myself = true
                                 self.accepted = false
                                print(results["request"]!["status"] as? String )
                                if let request_result =  results["request"]!["status"] as? String {
                                    if request_result == "1" {
                                      print(results["from"])
                                    if let user_data = results["from"] as? [String:AnyObject] {
                                        self.accepted = true
                                        self.headerData["second"] = "تفاصيل صاحب الخدمة"
                                        self.user_request["body"] = user_data["name"] as AnyObject
                                        self.user_request["title"] = "اسم صاحب الخدمة " as AnyObject
                                        self.user_request["image"] = "user" as AnyObject
                                        self.user_request["mobile"] = user_data["mobile"] as AnyObject
                                        self.user_request["id"] = user_data["id"] as AnyObject
                                        self.user_request["map"] = false as AnyObject
                                    }
                                }
                                }
                            }else{
                                if let request_result =  results["request"]!["status"] as? String {
                                     self.accepted = false
                                    if let user_data = results["user"] as? [String:AnyObject] {
                                        
                                        self.user_request["body"] = user_data["name"] as AnyObject
                                        self.user_request["title"] = "اسم صاحب الطلب " as AnyObject
                                        self.user_request["image"] = "user" as AnyObject
                                        self.user_request["mobile"] = user_data["mobile"] as AnyObject
                                        self.user_request["id"] = user_data["id"] as AnyObject
                                        self.user_request["map"] = false as AnyObject
                                    }
                                    if request_result == "1" {
                                         self.accepted = true
                                        
                                    }
                                }
                                
                            }
                        }
                        
                        
                        self.requestTableView.reloadData()
                    }
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
