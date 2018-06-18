//
//  menuViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/30/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class menuViewController: SuperParentViewController ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    var categories = [[String:String]]()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as? homeCollectionViewCell
        if checkUserData() {
            if indexPath.row == categories.count - 1 {
                cell?.backgroundContainer.image = UIImage(named:"boxred")
            }
        }
        cell?.iconImage.image = UIImage(named: categories[indexPath.row]["image"] as? String ?? "")
       
        cell?.titleLabel.text = categories[indexPath.row]["name"] as? String ?? ""
        cell?.containerView.ViewborderRound(border: 1, corner: 10)
        cell?.containerView.dropShadow()
        cell?.backgroundContainer.ImageBorderRadius(border: 0.5, corner: 10)
        cell?.backgroundView?.ViewborderRound(border: 1, corner: 10)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        staticNavigation = categories[indexPath.row]["name"] as? String ?? ""
        if categories[indexPath.row]["segue"] as? String == "share"  {
            let shareText = "حمل تطبيق ولا اسهل"
            let urlshare = URL (string: "https://itunes.apple.com/app/id1395804763" as! String)
            //check ipad
            let activityViewController = UIActivityViewController(activityItems: [urlshare], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.layer.bounds.width * 0.3,y: self.view.layer.bounds.height * 0.5,width: 0.00, height: 0.0)
            self.present(activityViewController, animated: true, completion: nil)
            return
        }
        if indexPath.row != categories.count - 1 {
            
            if let seguee = categories[indexPath.row]["segue"] as? String {
                
                self.performSegue(withIdentifier: seguee, sender: nil)
                
            }
        }else{
            if checkUserData() {
               
                    removeUserData()
                    removeData(name: "taxi")
                    removeData(name: "delivery")
                    let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
                    self.present(initialMain!, animated: true, completion: nil)
                
            }
            
            
          
            
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = CGFloat((collectionView.frame.size.width / 3) - 5  )
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourWidth)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuCollectionView.delegate = self
        self.menuCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        menuCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
       
        if checkUserData() {
            if isDelivery != true {
                categories.append(["name":"اضافة خدمة التوصيل","image":"plus_sq","segue":"showDeliveryRegister"])
            }
            if isTaxi != true {
                categories.append(["name":"اضافة خدمة التاكسي","image":"plus_sq","segue":"showTaxiRegister"])
            }
            userLabel.text = userData["name"] as? String ?? ""
            let userImage = userData["image"] as? String ?? ""
             self.userImage.sd_setImage(with: URL(string: image_url + userImage), placeholderImage: UIImage(named: "annonymus"))
            self.userImage.ImageBorderCircle()

            categories += [["name":"اضافة اعلان","image":"plus_sq","segue":"add_product"],["name":"الملف الشخصي","image":"user_c","segue":"profile"],
                           ["name":"الدردشة","image":"comment_co","segue":"user_chat"],["name":"الإعدادات","image":"setting_g","segue":"edit_profile"],
                           ["name":"عن التطبيق","image":"Exclamatio","segue":"showWebView"],["name":"تواصل معنا","image":"handset","segue":"showContact"],
                           ["name":"الشروط والاحكام","image":"pen_color","segue":"showWebView"],["name":"مشاركة التطبيق","image":"share","segue":"share"],
                           ["name":"تسجيل الخروج","image":"turn_off","segue":"signout"]]
            
        }else{
            userLabel.text = ""
            
            categories += [["name":"تسجيل الدخول","image":"plus_sq","segue":"showLogin"],["name":"عن التطبيق","image":"Exclamatio","segue":"showWebView"],["name":"تواصل معنا","image":"handset","segue":"showContact"],
                           ["name":"الشروط والاحكام","image":"pen_color","segue":"showWebView"],["name":"مشاركة التطبيق","image":"share","segue":"share"]]
        }
        self.menuCollectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.closeBtn.ButtonborderRoundradius(radius: 10)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft

        if openChat == true {
            openChat = false
            self.performSegue(withIdentifier: "user_chat", sender: nil)
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
       // self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeAction(_ sender: Any) {
        let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
      //  initialMain?.selectedIndex = 3
        
        self.present(initialMain!, animated: true, completion: nil)
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
