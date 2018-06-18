//
//  mainTabBarViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/30/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class mainTabBarViewController: UITabBarController ,UITabBarControllerDelegate{
    var selected_index = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        var barItems = self.tabBar.items
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().layer.masksToBounds = true
        UITabBar.appearance().layer.shadowColor = UIColor.lightGray.cgColor
        UITabBar.appearance().layer.shadowOpacity = 1
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 2.0)
        UITabBar.appearance().layer.shadowRadius = 10
        
        
        let item1 = barItems?[0]
        item1?.title = ""
        item1?.image = UIImage(named: "notification")
        
        let item2 = barItems?[1]
        item2?.title = ""
        item2?.image = UIImage(named: "menu")
        
        let item3 = barItems?[2]
        item3?.title = ""
        item3?.image = UIImage(named: "search")
        
        let item4 = barItems?[3]
        item4?.title = ""
        item4?.image = UIImage(named: "home")
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.delegate = self
        if selected_index == 2 {
            
        }else{
            
        }
        self.selectedIndex = selected_index
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
   // tabBar.selec
        print(self.selectedIndex)
        
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if  tabBarController.selectedIndex == 2 {
            searchView = true
              if let firstVC = viewController as? homeViewController {
            firstVC.topHeader.isHidden = true
            firstVC.topNavHeight.constant = 0
            }
        }else{
             if  tabBarController.selectedIndex == 3 {
                if let firstVC = viewController as? homeViewController {
                    firstVC.topHeader.isHidden = false
                    firstVC.topNavHeight.constant = 140
                }
            }
            
            searchView = false
        }
        print(tabBarController.selectedIndex)
        
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
