//
//  sliderTableViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 5/30/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import ImageSlideshow
class sliderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageSlideShow: ImageSlideshow!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
