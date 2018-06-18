//
//  deliveryRegisterViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 5/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit


class deliveryRegisterViewController: SuperParentViewController , UITableViewDelegate , UITableViewDataSource ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    var image = [String]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if image.count == 0 {
            return 4
        }
        return image.count
    }
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
     let yourWidth = CGFloat((self.view.frame.size.width / 3) - 10 )
     let yourHeight = yourWidth
     
     return CGSize(width: yourWidth, height: yourWidth)
     
     }
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImageCell", for: indexPath as IndexPath) as! addImageCollectionViewCell
        if image.count == 0 {
            cell.image.image = UIImage(named: "pic_profile")
        }else{
            cell.image.sd_setImage(with: URL(string: image_url + image[indexPath.row] as? String ?? ""), placeholderImage: UIImage(named: "pic_profile"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryRegisterCell") as! deliveryRegisterTableViewCell
        cell.imageCollectionView.delegate = self
        cell.imageCollectionView.dataSource = self
         cell.parent = self
        self.addTableView.setNeedsLayout()
        self.addTableView.layoutIfNeeded()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 625
    }
    
@IBOutlet weak var addTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "اضافة خدمة التوصيل"

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
