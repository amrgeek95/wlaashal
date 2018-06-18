//
//  notificationTableViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 6/4/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class notificationTableViewCell: UITableViewCell {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var type = ""
    
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
