//
//  LoginViewController.swift
//  Expand
//
//  Created by amr sobhy on 10/15/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast
import UserNotifications
class LoginViewController: SuperParentViewController {

    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let myColor = UIColor.clear
        emailText.layer.borderColor = myColor.cgColor
        passwordText.layer.borderColor = myColor.cgColor
       
        passwordText.layer.borderWidth = 0.7
        emailText.layer.borderWidth = 0.7
        signBtn.ButtonborderRoundradius(radius: 10)
        
        
        
        emailText.setTextIcon(image: "user_login")
         passwordText.setTextIcon(image: "password_icon")
        self.navigationItem.title = "تسجيل الدخول"
        
        // Do any additional setup after loading the view.
      //  self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func forgetAction(_ sender: Any) {
        let verificationView = self.storyboard?.instantiateViewController(withIdentifier: "verificationView") as? verificationViewController
        self.navigationController?.pushViewController(verificationView!, animated: true)
    }
    
    @IBOutlet weak var forgetPassword: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var homeBack: UIButton!
    @IBAction func homeAction(_ sender: Any) {
        let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "homeView") as? homeViewController
        self.present(initialMain!, animated: true, completion: nil)
    }
    @IBAction func loginBtn(_ sender: Any) {
        var parameters = [String: Any]()
        
        parameters["token"] = token
      
        parameters["username"] = emailText.text
        parameters["password"] = passwordText.text
        print(parameters)
        let login_url = base_url + "login"
        Alamofire.request(login_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        if let user_data = results["user"] as? [String:AnyObject] {
                            print(user_data)
                            userData = user_data
                            if Int(userData["driver"] as? String ?? "0") == 1 {
                                saveData(name: "driver")
                                isTaxi = true
                            }
                            if Int(userData["delivery"] as? String ?? "0")  == 1 {
                                saveData(name: "delivery")
                                isDelivery = true
                            }
                            saveUserData(userData: user_data as [String:AnyObject])
                            self.setNotification()
                            let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                            initialMain?.selectedIndex = 1
                            self.present(initialMain!, animated: true, completion: nil)
                        }else{
                            toastView(messsage:results["message"] as? String ?? "", view: self.view)
                        }
                    }else{
                        toastView(messsage:results["message"] as? String ?? "", view: self.view)
                    }
                   
                } else{
                     toastView(messsage:"حدث خطأ", view: self.view)
                }
            }else{
                toastView(messsage:"برجاء المحاولة مرة اخري", view: self.view)
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
