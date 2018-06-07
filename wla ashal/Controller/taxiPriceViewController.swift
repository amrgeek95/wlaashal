//
//  taxiPriceViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 6/2/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class taxiPriceViewController: SuperParentViewController {

    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    var addressFrom :addressMap!
    var addressTo :addressMap!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(addressTo)
        print(addressFrom)
        
        self.nextBtn.ButtonborderRoundradius(radius: 7)
        self.priceText.TextborderRound()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextAction(_ sender: Any) {
        var parameters = [String: Any]()
        if (priceText.text?.isEmpty)!{
            
            wla_ashal.toastView(messsage: "يجب كتابة السعر", view: self.view)
            return
        }
        parameters["token"] = token
        
        parameters["user_id"] = userData["id"]
        parameters["lat_to"] = addressTo.latitude
        parameters["long_to"] = addressTo.longtide
        parameters["address_to"] = addressTo.address
        parameters["city_to"] = addressTo.city
        
        parameters["address_from"] = addressFrom.address
        parameters["city_from"] = addressFrom.city
        parameters["lat_from"] = addressFrom.latitude
        parameters["long_from"] = addressFrom.longtide
        parameters["price"] = priceText.text
        print(parameters)
        let login_url = base_url + "taxi_request"
        Alamofire.request(login_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        
                         toastView(messsage:results["message"] as? String ?? "", view: self.view)
                        let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                        self.present(initialMain!, animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
