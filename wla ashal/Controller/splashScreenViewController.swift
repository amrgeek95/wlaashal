//
//  splashScreenViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import SideMenuController

class splashScreenViewController: UIViewController {
    var window: UIWindow?
    var counter = 2
    var time = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft

         time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    @objc func updateCounter() {
        
        if counter == 0 {
            time.invalidate()
           
            self.performSegue(withIdentifier: "initiateMain", sender: nil)
        }
        counter -= 1
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
