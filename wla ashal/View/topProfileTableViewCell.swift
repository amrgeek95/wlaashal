//
//  topProfileTableViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 5/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import FloatRatingView
class topProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var callImg: UIImageView!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var pointsNumber: UIButton!
    @IBOutlet weak var followersNumber: UIButton!
    @IBOutlet weak var followingNumber: UIButton!
    @IBOutlet weak var adsLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var adsBtn: UIButton!
    var parent :profileViewController!
    
    @IBOutlet weak var userReview: FloatRatingView!
    
    @IBOutlet weak var codeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.codeBtn.ButtonborderRoundradius(radius: 9)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
