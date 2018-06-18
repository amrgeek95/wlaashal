//
//  homeViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/23/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage
import FloatRatingView

class homeViewController: SuperParentViewController ,UICollectionViewDelegate , UICollectionViewDataSource ,UISearchBarDelegate ,UITabBarControllerDelegate{

    @IBOutlet weak var userReview: FloatRatingView!
    @IBOutlet weak var nav_height: NSLayoutConstraint!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var adsLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var adsBtn: UIButton!
    @IBOutlet weak var pointBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var navigationBtn: UIButton!
    
    private var mySearchBar: UISearchBar!
    
    @IBOutlet weak var topNavHeight: NSLayoutConstraint!
    @IBOutlet weak var topHeader: UIView!
    
    var mySearchtext = ""
    var old = false
    var recentSearch = true
    
    var categories = [Dictionary<String,AnyObject>]()
    var service = ["showTaxi","showModal"]
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return self.categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as? homeCollectionViewCell
       
        cell?.iconImage.sd_setImage(with: URL(string: categories[indexPath.row]["image"] as? String ?? ""), placeholderImage: UIImage(named: "car_d"))
        cell?.titleLabel.text = categories[indexPath.row]["name"] as? String ?? ""
        cell?.id = categories[indexPath.row]["id"] as? String ?? ""
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row  > 1 {
            let showList = self.storyboard?.instantiateViewController(withIdentifier: "listProductsView") as? listProductsViewController
            showList?.category_id = categories[indexPath.row]["id"] as? String ?? ""
            //self.present(showList!, animated: true, completion: nil)
            self.navigationController?.pushViewController(showList!, animated: true)
        }else{
            if checkUserData() {
             
                self.performSegue(withIdentifier: service[indexPath.row], sender: nil)
            }else{
                let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
                self.navigationController?.pushViewController(loginView!, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = CGFloat((collectionView.frame.size.width / 3) - 5 )
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourWidth)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchView == false {
            get_categories()
        }
       
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        // Do any additional setup after loading the view.
         homeCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
    }
    func tapLogin(_ sender:UITapGestureRecognizer) {
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
        self.navigationController?.pushViewController(loginView!, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_categories(){
        self.categories.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
        
        self.categories.append((["name":"تاكسي","id":0,"image":"taxi"] as? [String:AnyObject])!)
        
        self.categories.append((["name":"التوصيل","id":0,"image":"car_d"] as? [String:AnyObject])!)
        var url = base_url + "get_category"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                
                if  let result = results["categories"] as? [[String:String]] {
                    print(result)
                    for str:[String:String] in result {
                        print(str)
                        var each_list = [String:AnyObject]()
                        each_list["name"] =  str["name"]! as AnyObject
                        each_list["id"] =  str["id"] as AnyObject
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                        self.categories.append(each_list)
                        print(self.categories)
                    }
                    self.homeCollectionView.reloadData()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = ""
        self.navigationBtn.addTarget(nil, action: #selector(self.openMenu(sender:)), for: .touchUpInside)
        if searchView == true {
            topHeader.isHidden = true
            topNavHeight.constant = 0
            mySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
            mySearchBar.delegate = self
            //   lazy var mySearchBar = UISearchBar(frame: CGRect.zero)
            // hide cancel button
            // mySearchBar.showsCancelButton = true
            
            // hide bookmark button
            mySearchBar.showsBookmarkButton = false
            
            // set Default bar status.
            mySearchBar.searchBarStyle = UISearchBarStyle.default
            
            // set title
            
            
            // set placeholder
            mySearchBar.placeholder = "بحث"
            mySearchBar.setValue("إلغاء", forKey:"_cancelButtonText")
            mySearchBar.setValue("custom", forKey: "cancelButtonText")
            
            
            
            
            // change the color of cursol and cancel button.
            mySearchBar.tintColor = UIColor(hexString: "#21A6DF")
            
            // hide the search result.
            mySearchBar.showsSearchResultsButton = false
            mySearchBar.semanticContentAttribute = .forceRightToLeft
            // add searchBar to the view.
            mySearchBar.sizeToFit()
            navigationItem.titleView = mySearchBar
            self.navigationController?.navigationBar.isHidden = false
        }else{
            topHeader.isHidden = false
            topNavHeight.constant = 140
        }
        if !checkUserData() {
            //nav_height: NSLayoutConstraint!
            
            userLabel.text = "اضغط هنا للتسجيل"
            adsLabel.isHidden = true
            adsBtn.isHidden = true
            pointBtn.isHidden = true
            adsLabel.isHidden = true
            pointLabel.isHidden = true
            let tapGesture = UITapGestureRecognizer(target:self,action: #selector(self.tapLogin(_:)))
            self.userLabel.addGestureRecognizer(tapGesture)
            self.userImage.addGestureRecognizer(tapGesture)
            self.userReview.isHidden = true
            
            
        }else{
            loadUserData()
            userReview.rating = userData["rate"] as? Float ?? 5
            userReview.rating = Float(userData["rate"] as? String ?? "5")!
            
            self.userLabel.text = userData["name"] as? String ?? ""
            let userImage = userData["image"] as? String ?? ""
            self.userImage.sd_setImage(with: URL(string: image_url + userImage), placeholderImage: UIImage(named: "annonymus"))
            self.adsBtn.setTitle("\(userData["ads_count"] as? Int ?? 0)", for: .normal)
            self.pointBtn.setTitle(userData["points"] as? String ?? "", for: .normal)
            self.userImage.ImageBorderRadius(border: 0.2, corner: 25)
            adsLabel.isHidden = false
            
            pointLabel.isHidden = false
             self.userReview.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
          if searchView == true {
            self.topHeader.isHidden = true
            self.topNavHeight.constant = 0
            
            self.navigationController?.navigationBar.isHidden = false
          }  else{
            self.navigationController?.navigationBar.isHidden = true
            self.topHeader.isHidden = false
            self.topNavHeight.constant = 140
        }
        
    }
    func openMenu (sender:UIButton){
        let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController
        initialMain?.selected_index = 1
        self.present(initialMain!, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // search section
    
   
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        mySearchtext = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
        mySearchBar.text = ""
        let imageViewBar = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageViewBar.contentMode = .scaleAspectFit
        let imagebar = UIImage(named: "Logoblue")
        imageViewBar.image = imagebar
        navigationItem.titleView = imageViewBar
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mySearchtext =  mySearchBar.text!
        
        print("## search btn clicked : \(searchBar.text ?? "")")
        print(mySearchBar.text!)
        searchBar.endEditing(true)
        searchBar.text = nil
        recentSearch = false
        let showList = self.storyboard?.instantiateViewController(withIdentifier: "listProductsView") as? listProductsViewController
        showList?.searchText = mySearchtext
        showList?.searchFlag = true
        //self.present(showList!, animated: true, completion: nil)
        self.navigationController?.pushViewController(showList!, animated: true)
        
    }
    


}
