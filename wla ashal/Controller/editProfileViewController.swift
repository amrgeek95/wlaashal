//
//  editProfileViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 6/2/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class editProfileViewController: SuperParentViewController  ,UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var editTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editProfileCell") as? editProfileTableViewCell
        let userImage = userData["image"] as? String ?? ""
        cell?.userImage.sd_setImage(with: URL(string: image_url + userImage ), placeholderImage: UIImage(named: "pic_profile"))
        cell?.nameText.text = userData["name"] as? String ?? ""
        cell?.emailText.text = userData["username"] as? String ?? ""
        cell?.mobileText.text = userData["mobile"] as? String ?? ""
        
        cell?.parent = self
        return cell!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTableView.delegate = self
        self.editTableView.dataSource = self
        
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

