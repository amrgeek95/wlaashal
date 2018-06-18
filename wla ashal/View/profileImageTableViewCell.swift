//
//  profileImageTableViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 5/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class profileImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    var parent: profileViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.imageCollectionView.reloadData()

        // Configure the view for the selected state
    }
    


}
