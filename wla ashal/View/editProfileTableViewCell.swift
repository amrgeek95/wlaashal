//
//  editProfileTableViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 6/2/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast

import MBProgressHUD
import ImagePicker
import Lightbox
class editProfileTableViewCell: UITableViewCell  ,  ImagePickerDelegate {
    var parent:editProfileViewController!
    
    var imageString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        signup.ButtonborderRound()
        
        let myColor = UIColor.clear
        nameText.layer.borderColor = myColor.cgColor
        mobileText.layer.borderColor = myColor.cgColor
        emailText.layer.borderColor = myColor.cgColor
        passwordText.layer.borderColor = myColor.cgColor
        
        nameText.layer.borderWidth = 0.9
        mobileText.layer.borderWidth = 0.9
        emailText.layer.borderWidth = 0.9
        passwordText.layer.borderWidth = 0.9
        //  self.parent.navigationItem.title = "تسجيل جديد"
        self.mobileText.keyboardType = .asciiCapableNumberPad
        let gesture = UITapGestureRecognizer(target:self,action:#selector(self.tapImage(_:)))
        self.userImage.isUserInteractionEnabled = true
        self.userImage.addGestureRecognizer(gesture)
        
        
    }
    func tapImage(_ sender:UITapGestureRecognizer) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 6
        self.parent.present(imagePickerController, animated: true, completion: nil)
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        // let images = imageAssets
        MBProgressHUD.showAdded(to: self.parent.view, animated: true)
        var upload_url = base_url + "upload_image"
        // images is he return from the delegate
        print(images)
        var imageParamName = "parameters"
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for image in images {
                let imageData =  UIImageJPEGRepresentation(image, 0)!
                multipartFormData.append(imageData, withName: "\(imageParamName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
        }, to: upload_url,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("success")
                    print(response)
                    MBProgressHUD.hide(for: self.parent.view, animated: true)
                    if let results = response.result.value as? [String:AnyObject]{
                        if let result_image = results["images"] as? [String] {
                            self.imageString = result_image.first ?? ""
                            self.userImage.sd_setImage(with: URL(string: image_url + self.imageString), placeholderImage: UIImage(named: "pic_profile"))
                            print(self.imageString)
                            
                        }else{
                            print("why")
                            
                            MBProgressHUD.hide(for: self.parent.view, animated: true)
                            wla_ashal.toastView(messsage: "حدث خطأ اعد المحاولة", view: self.parent.view)
                        }
                    }
                    
                }
            case .failure(let error):
                print(error)
                MBProgressHUD.hide(for: self.parent.view, animated: true)
                wla_ashal.toastView(messsage: "حدث خطأ اعد المحاولة", view: self.parent.view)
            }
            
        })
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var codeText: UITextField!
    
    @IBOutlet weak var repassword: UITextField!
    @IBAction func signUpBtn(_ sender: Any) {
        var parameters = [String: Any]()
        let name =  nameText.text
        let mobile =  mobileText.text
        let uEmail =  emailText.text
        let uPassword =  passwordText.text
        
        
        guard self.checkValidation(name: name!, email: uEmail!, mobile: mobile!, password: uPassword!) else {
            return
        }
        
        if Reachability.isConnectedToNetwork(){
            
            parameters["token"] = token
            parameters["name"] = name
            parameters["ثةشهم"] = mobile
            parameters["username"] = emailText.text
            parameters["password"] = passwordText.text
            parameters["image"] = imageString
            print(parameters)
            let register_url = base_url + "edit"
            print(register_url)
            Alamofire.request(register_url, method: .get, parameters: parameters).responseJSON{
                (response) in
                print(response)
                
                
                if  let results = response.result.value as? [String:AnyObject] {
                    print(results["message"])
                    if results["status"] as? Bool == true {
                        if let user_data = results["user"] as? [String:AnyObject] {
                            print(userData)
                            saveUserData(userData: user_data as [String:AnyObject])
                            userData = user_data
                            //  application.registerForRemoteNotifications()
                            //  self.setNotification()
                            let initialMain = self.parent.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                            self.parent.present(initialMain!, animated: true, completion: nil)
                        }
                    }else{
                        wla_ashal.toastView(messsage:results["message"] as? String ?? "", view: self.parent.view)
                    }
                }else{
                    wla_ashal.toastView(messsage:"حدث خطأ", view: self.parent.view)
                }
                
            }
        }else{
            self.parent.view.makeToast("يرجي التأكد من وجود شبكة ")
        }
        
    }
    func checkValidation(name: String,email: String, mobile: String, password:String ) -> Bool{
        
        if name.isEmpty{
            
            wla_ashal.toastView(messsage: "يجب كتابة اسم المستخدم", view: self.parent.view)
            return false
        }
        if mobile.isEmpty{
            wla_ashal.toastView(messsage:"يجب كتابة رقم الجوال", view: self.parent.view)
            return false
        }
        /*
         if mobile.characters.count != 10 {
         wla_ashal.toastView(messsage:"يرجي كتابة ١٠ ارقام صحيحة للجوال", view: self.parent.view)
         return false
         }
         */
        if email.isEmpty{
            wla_ashal.toastView(messsage:"يرجي ادخال البريد الالكتروني", view: self.parent.view)
            return false
        }else if !Utilities.isEmailValidation(email){
            wla_ashal.toastView(messsage:"ادخل البريد بطريقة صحيحة", view: self.parent.view)
            return false
        }
        
        
        
        if password.isEmpty{
            wla_ashal.toastView(messsage:"يجب ادخال كلمة المرور", view: self.parent.view)
            return false
        }
        
        return true
        
    }
    @IBOutlet weak var signup: UIButton!
    
    
}

