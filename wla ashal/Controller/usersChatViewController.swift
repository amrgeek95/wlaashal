//
//  usersChatViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/8/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
class usersChatViewController: UIViewController,UITableViewDelegate ,UITableViewDataSource {
    var usersArray = [Dictionary<String,AnyObject>]()
    var chat_id = ""
    var otherId = ""
    var otherName = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
       self.performSegue(withIdentifier: "showChat", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "مسح", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            self.deleteChat(selectedChat: indexPath.row)
            success(true)
        })
        //closeAction.image = UIImage(named: "user_icon")
        closeAction.backgroundColor = .red
        
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    func deleteChat(selectedChat:Int){
        var parameters = [String:AnyObject]()
        parameters["user_id"] = userData["id"] as AnyObject
        parameters["chat_id"] = usersArray[selectedChat]["chat_id"] as AnyObject
        print(parameters)
        
        let delete_chat_url = base_url + "delete_chat"
        Alamofire.request(delete_chat_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if let results = response.result.value as? [String:AnyObject]{
                if results["status"] as? Bool == true {
                    wla_ashal.toastView(messsage: "تم المسح", view: self.view)
                    self.usersArray.remove(at: selectedChat)
                    self.usersTableView.reloadData()
                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "مسح", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            self.deleteChat(selectedChat: indexPath.row)
            success(true)
        })
        //closeAction.image = UIImage(named: "user_icon")
        closeAction.backgroundColor = .red
        
        
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersChatCell") as? usersChatTableViewCell
//        cell?.contentView.backgroundColor = UIColor.clear
        cell?.bodyLabel.text = usersArray[indexPath.row]["last_message"] as? String ?? ""
        cell?.nameLabel.text = usersArray[indexPath.row]["name"] as? String ?? ""
        cell?.usernameLabel.text = usersArray[indexPath.row]["username"] as? String ?? ""
        cell?.chat_id = usersArray[indexPath.row]["chat_id"] as? String ?? ""
        cell?.otherId = usersArray[indexPath.row]["to_id"] as? String ?? ""
        cell?.otherName = usersArray[indexPath.row]["name"] as? String ?? ""
        cell?.notificationView.isHidden = true
        if usersArray[indexPath.row]["seen"] as? Bool == false {
         cell?.notificationView.isHidden = false
        }
        cell?.parent = self
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" ,
            let nextScene = segue.destination as? parentChatViewController ,
            let indexPath = self.usersTableView.indexPathForSelectedRow {
            nextScene.chat_id = usersArray[indexPath.row]["chat_id"] as? String ?? ""
            nextScene.otherId = usersArray[indexPath.row]["to_id"] as? String ?? ""
            nextScene.otherName = usersArray[indexPath.row]["name"] as? String ?? ""
          //  nextScene.currentVehicle = selectedVehicle
        }
    }
    

    @IBOutlet weak var usersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        get_userChat()
        // Do any additional setup after loading the view.
        
        usersTableView.rowHeight = UITableViewAutomaticDimension
        usersTableView.allowsSelection = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "الرسائل"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func get_userChat(){
        var parameters = [String:AnyObject]()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        parameters["user_id"] = userData["id"] as? AnyObject
     
        print(parameters)
        var chat_url = base_url+"get_chat"
        Alamofire.request(chat_url, method: .get, parameters: parameters).responseJSON {
            (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response)
            
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                
                if let status = results["status"] as? Bool {
                    if let chats = results["chats"] as? [[String:AnyObject]]{
                        for chat:[String:AnyObject] in chats {
                            self.usersArray.append(chat)
                        }
                    }
                    self.usersTableView.reloadData()
                    
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
