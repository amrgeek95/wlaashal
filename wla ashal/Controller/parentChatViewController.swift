//
//  parentChatViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/7/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast
import MBProgressHUD
class parentChatViewController: SuperParentViewController {
    var chat_id = ""
    var otherId = ""
    var otherName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = otherName
         self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft
         self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
   
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceLeftToRight
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedChat" ,
            let nextScene = segue.destination as? chatViewController  {
            print(self.chat_id)
            print(self.otherId)
            nextScene.chat_id = self.chat_id
            nextScene.otherId = self.otherId
            nextScene.otherName = self.otherName
            //  nextScene.currentVehicle = selectedVehicle
        }
    }
    
    func sendMsg(msg:AnyObject, type:String,is_url:Bool?=false ,imageDate :UIImage? = nil, media : AnyObject? = nil) {
        var parameters:[String:AnyObject] = [String:AnyObject]()
        parameters["user_id"] = userData["id"] as AnyObject?
        parameters["message"] = msg
        parameters["to_id"] = otherId as AnyObject?
        parameters["chat_id"] = 0 as AnyObject
        let send_url = base_url + "send_message"
        Alamofire.request(send_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            if let results = response.result.value as? [String:AnyObject] {
                if let status = results["status"] as? Bool {
                    var msgParse = ["from_id":userData["id"],"to_id":self.otherId,"chat_id":1,"message":msg]
                    
                }
            }
            
        }
        // self.messages[self.messages.count-1].messageStatus = "Sent"
       
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
