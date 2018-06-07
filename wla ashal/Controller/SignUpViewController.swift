//
//  SignUpViewController.swift
//  Expand
//
//  Created by amr sobhy on 12/7/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast
import UserNotifications
class SignUpViewController: SuperParentViewController  ,UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "signUpCell") as? signUpTableViewCell
       cell?.parent = self
        return cell!
    }
    

    @IBOutlet weak var signupTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signupTableView.delegate = self
        self.signupTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
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
