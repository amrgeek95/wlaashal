//
//  listProductCollectionViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 5/23/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import FloatRatingView
class listProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userReview: FloatRatingView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
   
    @IBOutlet weak var containerView: UIView!
    var id = ""
}
