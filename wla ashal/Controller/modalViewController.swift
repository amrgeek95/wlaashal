//
//  modalViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 6/2/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
import CoreLocation
class modalViewController: UIViewController  , UIGestureRecognizerDelegate ,CLLocationManagerDelegate{
    var tap: UITapGestureRecognizer!

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    let locationManager = CLLocationManager()

    var user_address :addressMap!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.ViewborderRound(border: 0.3, corner: 10)
        sendBtn.ButtonborderRoundradius(radius: 7)
        titleText.TextborderRound()
        priceText.TextborderRound()
        // Do any additional setup after loading the view.
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.window?.isUserInteractionEnabled = true
        self.view.window?.addGestureRecognizer(tap)
        user_address = addressMap(longtide: 0.0, latitude: 0.0, address: "", city: "")
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            user_address.longtide = (locationManager.location?.coordinate.longitude)!
            user_address.latitude = (locationManager.location?.coordinate.latitude)!
        }
       
    }
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)
        
        if self.view.point(inside: location, with: nil) {
            return false
        }
        else {
            return true
        }
    }
     func onTap(sender: UITapGestureRecognizer) {
        
        self.view.window?.removeGestureRecognizer(sender)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendAction(_ sender: Any) {
        var parameters = [String: Any]()
        if (priceText.text?.isEmpty)!{
            
            wla_ashal.toastView(messsage: "يجب كتابة السعر", view: self.view)
            return
        }
        if (titleText.text?.isEmpty)!{
            
            wla_ashal.toastView(messsage: "يجب كتابة ما تريد شراءة", view: self.view)
            return
        }
        parameters["token"] = token
        
        parameters["user_id"] = userData["id"]
        parameters["lat"] = user_address.latitude
        parameters["long"] = user_address.longtide
        parameters["address"] = user_address.address
        parameters["city"] = user_address.city
        parameters["title"] = titleText.text
        parameters["price"] = priceText.text
        print(parameters)
        let login_url = base_url + "delivery_request"
        Alamofire.request(login_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        
                        let alert = UIAlertController(title: results["message"] as? String ?? "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler:{ (alert: UIAlertAction!) -> Void in
                            let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                            initialMain?.selectedIndex = 1
                            self.present(initialMain!, animated: true, completion: nil)
                        }
                        ))
                        self.present(alert, animated: true, completion: nil)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first as! UITouch
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != containerView {
            self.dismiss(animated: true, completion: nil)
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
