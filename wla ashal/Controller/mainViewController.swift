//
//  mainViewViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import SideMenuController

class mainViewController: SideMenuController {
    var chatFlag = 0
    var tabBarControllers = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "homeView")
        let tabViewController2 = self.storyboard?.instantiateViewController(withIdentifier: "searchView")
        let tabViewController3 = self.storyboard?.instantiateViewController(withIdentifier: "menuView")
        let tabViewController4 = self.storyboard?.instantiateViewController(withIdentifier: "messageView")
        
        // create the view controllers for center containment
        
        let nc1 = UINavigationController(rootViewController: tabViewController1!)
        let nc2 = UINavigationController(rootViewController: tabViewController2!)
        let nc3 = UINavigationController(rootViewController: tabViewController3!)
        let nc4 = UINavigationController(rootViewController: tabViewController4!)
        
        
        
        
        
        tabViewController1?.tabBarItem = UITabBarItem(
            title: "",
            
            image: UIImage(named: "home"),
            tag: 1)
        tabViewController2?.tabBarItem = UITabBarItem(
            title: "",
            image:UIImage(named: "search") ,
            tag:2)
        tabViewController3?.tabBarItem = UITabBarItem(
            title: "",
            image:UIImage(named: "menu") ,
            tag:3)
        tabViewController4?.tabBarItem = UITabBarItem(
            title: "",
            image:UIImage(named: "comment_co") ,
            tag:4)
        tabBarControllers.viewControllers = [nc1, nc2, nc3 , nc4]
        
        // create the side controller
        //performSegue(withIdentifier: "showHome", sender: nil)
        //  performSegue(withIdentifier: "containSideMenu", sender: nil)
        //  self.embed(centerViewController: UINavigationController(rootViewController:tabBarController))
        let sideController = self.storyboard?.instantiateViewController(withIdentifier: "menuController")
        
        // embed the side and center controllers
        sideMenuController?.embed(sideViewController: sideController!)
        sideMenuController?.embed(centerViewController: tabBarControllers)
        
        // add the menu button to each view controller embedded in the tab bar controller
        
        [nc1, nc2, nc3,nc4].forEach({ controller in
            controller.addSideMenuButton()
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if chatFlag == 1 {
            
            tabBarControllers.selectedIndex = 2
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

