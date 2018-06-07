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
        return cell
    }
    

    @IBOutlet weak var notificationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if checkUserData(){
         
            self.get_notification()
        }
        self.navigationItem.title = "الاشعارات"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func get_notification(){
        self.notification.removeAll()
        var parameters = [String:Any]()
        if isDelivery == true {
            parameters["taxi"] = true
        }
        if isTaxi == true {
            parameters["delivery"] =  true
        }
      
       
        parameters["user_id"] = userData["id"]
        let notification_url = base_url + "notifications"
        print(parameters)
        
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
