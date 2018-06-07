//
//  contactViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 6/1/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

import Alamofire
import Toast
import UserNotifications
class contactViewController: SuperParentViewController  ,UITextViewDelegate{
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var body: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let myColor = UIColor.clear
      
        sendBtn.ButtonborderRoundradius(radius: 10)
        
        
        self.body.text = "اكتب محتوي الرسالة"
        self.body.textColor = UIColor.lightGray
        self.body.delegate = self
        self.body.textAlignment = .right
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        body.layer.borderColor = color
        body.layer.borderWidth = 0.5
        body.layer.cornerRadius = 5
        body.isSelectable = true
        body.isEditable = true
        
        
        
        // Do any additional setup after loading the view.
        //  self.navigationController?.isNavigationBarHidden = true
    }

    @IBOutlet weak var sendBtn: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAction(_ sender: Any) {
        var parameters = [String: Any]()
        
        parameters["name"] = nameText.text
        
        parameters["email"] = emailText.text
        parameters["title"] = titleText.text
        parameters["comment"] = body.text
        print(parameters)
        let login_url = base_url + "send_feedback"
        Alamofire.request(login_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        toastView(messsage:results["message"] as? String ?? "", view: self.view)
                    }else{
                        toastView(messsage:results["message"] as? String ?? "", view: self.view)
                    }
                    let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                    initialMain?.selectedIndex = 1
                    
                    self.present(initialMain!, animated: true, completion: nil)
                } else{
                    toastView(messsage:"حدث خطأ", view: self.view)
                    let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                    initialMain?.selectedIndex = 1
                    
                    self.present(initialMain!, animated: true, completion: nil)
                }
            }else{
                toastView(messsage:"برجاء المحاولة مرة اخري", view: self.view)
            }
            
            
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        if textView.text.isEmpty {
            textView.text = "اكتب محتوي الرسالة"
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "تواصل معنا"
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
