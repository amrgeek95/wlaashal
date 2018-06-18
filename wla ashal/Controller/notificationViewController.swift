//
//  notificationViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 6/4/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast
import MBProgressHUD
class notificationViewController: SuperParentViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var changeBtn: UISegmentedControl!
    var request_type = 0
    @IBAction func changeAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            request_type = 1
            get_notification(my_request: true)
        }else{
            request_type = 0
            get_notification(my_request: false)
        }
    }
    var notification = [Dictionary<String,AnyObject>]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showRequest = self.storyboard?.instantiateViewController(withIdentifier: "requestView") as? requestViewController
        showRequest?.id = self.notification[indexPath.row]["id"] as? String ?? ""
        showRequest?.type = self.notification[indexPath.row]["type"]  as? String ?? ""
        print(self.notification[indexPath.row]["type"]  as? String ?? "")
        
        self.navigationController?.pushViewController(showRequest!, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! notificationTableViewCell
        cell.nameLabel.text = notification[indexPath.row]["user"] as? String ?? ""
        cell.dateLabel.text = notification[indexPath.row]["date"] as? String ?? ""
        cell.messageLabel.text  = notification[indexPath.row]["message"] as? String ?? ""
        cell.type = notification[indexPath.row]["type"] as? String ?? ""
        let userImg = notification[indexPath.row]["image"] as? String ?? ""

        cell.userImage.sd_setImage(with: URL(string: image_url + userImg), placeholderImage: UIImage(named: "Asset 9"))
        cell.userImage.ImageBorderCircle()
        cell.containerView.ViewborderRound(border: 0.2, corner: 20)
        cell.containerView.dropShadow()
        if request_type == 0 {
            
            cell.typeLabel.isHidden = true
        }else{
            cell.typeLabel.isHidden = false
            cell.typeLabel.text = notification[indexPath.row]["type_label"] as? String ?? ""
        }
        
        return cell
    }
    

    @IBOutlet weak var notificationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        request_type = 0
        if checkUserData(){
            
            get_notification(my_request: false)
            if isDelivery == true {
                 self.changeBtn.isHidden = false
            }else if isTaxi == true {
                 self.changeBtn.isHidden = false
            }else {
                self.changeBtn.isHidden = true
            }
           
        }else{
           self.changeBtn.isHidden = true
        }
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 106/255, green: 163/255, blue: 147/255, alpha: 1.0)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .selected)
        self.navigationItem.title = "الاشعارات"
        self.changeBtn.setTitle("طلباتي", forSegmentAt: 1)
        self.changeBtn.selectedSegmentIndex = 0
        self.changeBtn.setTitle("طلبات العملاء", forSegmentAt: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func get_notification(my_request:Bool = false){
        self.notification.removeAll()
        var parameters = [String:Any]()
        var onlyme = true
        if my_request == true {
            parameters["type"] = 0
        }
        if isDelivery == true {
            onlyme = false
            parameters["taxi"] = true
        }
        if isTaxi == true {
            parameters["delivery"] =  true
             onlyme = false
        }
      
        if onlyme == true {
            parameters["type"] = 0
        }
        parameters["user_id"] = userData["id"]
        let notification_url = base_url + "notifications"
        print(parameters)
MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(notification_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                
                advanced_flag = false
                if  let result = results["requests"] as? [[String:AnyObject]] {
                    print(result)
                    for str:[String:AnyObject] in result {
                        print(str)
                        
                        var each_list = [String:AnyObject]()
                        
                        each_list["user"] =  str["user"]! as AnyObject
                        each_list["id"] =  str["id"] as AnyObject
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                        each_list["date"] =  str["date"] as AnyObject
                        each_list["message"] =  str["message"] as AnyObject
                        each_list["type"] =  str["type"] as AnyObject
                       var textlabel = ""
                        if each_list["type"] as? String == "taxi"{
                            textlabel = "تاكسي "
                        } else {
                              textlabel = "توصيل "
                        }
                        if str["user_id"] as? String !=  userData["id"] as? String{
                            each_list["type_label"] = textlabel + " - طلب وارد " as AnyObject
                        }else{
                            each_list["type_label"] = textlabel + " - طلب صادر " as AnyObject
                            
                        }
                       
                        self.notification.append(each_list)
                        
                        
                        print(self.notification)
                    }
                    self.notificationTableView.reloadData()
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
