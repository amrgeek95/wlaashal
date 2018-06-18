//
//  profileImageCollectionViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 5/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import FloatRatingView
class profileImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userReview: FloatRatingView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    var id = ""
    
    
    
}
