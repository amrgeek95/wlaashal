//
//  deliveryRegisterTableViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 5/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

import Alamofire
import MBProgressHUD
import ImagePicker
import Lightbox
class deliveryRegisterTableViewCell: UITableViewCell ,UITextViewDelegate ,ImagePickerDelegate{
    var parent : deliveryRegisterViewController!
    var imageArray = [String]()
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleText : UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var subTitle: UITextField!
    
    @IBOutlet weak var secondTitle: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var bodyTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.secondTitle.keyboardType = .asciiCapableNumberPad
        self.bodyTextView.text = "اكتب محتوي الاعلان"
        self.bodyTextView.textColor = UIColor.lightGray
        self.bodyTextView.delegate = self
        self.bodyTextView.textAlignment = .right
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        bodyTextView.layer.borderColor = color
        bodyTextView.layer.borderWidth = 0.5
        bodyTextView.layer.cornerRadius = 5
        bodyTextView.isSelectable = true
        bodyTextView.isEditable = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var imageBtn: UIButton!
    @IBAction func imageAction(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 6
        imagePickerController.modalPresentationStyle = .overCurrentContext

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
            /*
             for (key, value) in parameters {
             multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
             }
             */
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
                            self.imageArray = result_image
                            self.parent.image = result_image
                            self.imageCollectionView.reloadData()
                            
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
    @IBAction func submitAction(_ sender: Any) {
        var parameters = [String:AnyObject]()
        self.saveBtn.isEnabled = false
        guard inputValidation(text: self.titleText.text!, message: "يجب كتابة عنوان للأعلان", view: self.parent.view) else{
            self.saveBtn.isEnabled = true
            return
        }
        let title = self.titleText.text!
        print("titlLEngth\(title.length)")
        if title.length > 30 {
            wla_ashal.toastView(messsage: "عنوان الاعلان طويل جدا", view: self.parent.view)
            self.saveBtn.isEnabled = true
            return
        }
        if bodyTextView.textColor == UIColor.lightGray {
            wla_ashal.toastView(messsage: "يجب كتابة محتوي الاعلان", view: self.parent.view)
            self.saveBtn.isEnabled = true
            return
        }
        guard inputValidation(text: bodyTextView.text!, message: "يجب كتابة محتوي الاعلان", view: self.parent.view) else{
            self.saveBtn.isEnabled = true
            return
        }
        guard !imageArray.isEmpty else {
            wla_ashal.toastView(messsage: "يجب رفع صورة واحدة علي الاقل", view: self.parent.view)
            self.saveBtn.isEnabled = true
            return
        }
        
        parameters["name"] = titleText.text as AnyObject
        parameters["user_id"] = userData["id"] as AnyObject
        parameters["car_number"] = subTitle.text as AnyObject
        parameters["mobile"] = secondTitle.text as AnyObject
        parameters["body"] = bodyTextView.text as AnyObject
        parameters["images"] = imageArray as AnyObject
        var url = base_url + "delivery_register"
        print(parameters)
        
        MBProgressHUD.showAdded(to: self.parent.view, animated: true)
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            self.saveBtn.isEnabled = true
            MBProgressHUD.hide(for: self.parent.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                if results["status"] as? Bool == true {
                    self.parent.view.makeToast("تم تسجيل الطلب")
                    let initialMain = self.parent.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                    initialMain?.selectedIndex = 1
                    saveData(name: "delivery")
                    isDelivery = true
                    self.parent.present(initialMain!, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        if textView.text.isEmpty {
            textView.text = "اكتب محتوي الاعلان"
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
    }
    
}

