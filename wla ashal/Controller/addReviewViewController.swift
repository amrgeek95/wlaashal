//
//  addReviewViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 6/6/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import FloatRatingView
import Alamofire
import MBProgressHUD

class addReviewViewController: SuperParentViewController ,FloatRatingViewDelegate{
        var rate = "0"
    var user_id  = ""
    var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        userReview.delegate = self
          userReview.setupFloatEdit(index: 0)
        containerView.ViewborderRound(border: 0.3, corner: 10)
        sendBTn.ButtonborderRoundradius(radius: 7)
        comment.TextborderRound()
        

    }

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var userReview: FloatRatingView!
    @IBOutlet weak var containerView: UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var sendBTn: UIButton!
    @IBOutlet weak var comment: UITextField!
    
    @IBAction func sendAction(_ sender: Any) {
        var parameters = [String:AnyObject]()
      
        
        parameters["comment"] = comment.text as AnyObject
        parameters["user_id"] = user_id as AnyObject
        parameters["from_id"] = userData["id"] as AnyObject
        parameters["rate"] = rate as AnyObject
      
        var url = base_url + "add_review"
        print(parameters)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                if let status = results["status"] as? Bool {
                  wla_ashal.toastView(messsage: results["message"] as? String ?? "" , view: self.view)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float){
        
         rate  = String(format: "%.2f", ratingView.rating)
        print("rating Edit \(ratingView.tag) \(String(format: "%.2f", ratingView.rating))")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first as! UITouch
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != containerView {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
extension FloatRatingView {
    func setupFloatEdit (index:Int,editable:Bool = true ,rate:Double = 1.0) {
        
        self.backgroundColor = UIColor.clear
        self.tag = index
        self.contentMode = UIViewContentMode.scaleAspectFit
        
      //  self.type = .halfRatings
        self.maxRating = 5
        self.minRating = 1
        self.rating = Float(rate)
        self.editable = true
    }
}
