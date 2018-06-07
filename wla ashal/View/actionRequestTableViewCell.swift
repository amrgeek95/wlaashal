//
//  actionRequestTableViewCell.swift
//  wla ashal
//
//  Created by amr sobhy on 6/3/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class actionRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptAction: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    var id = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func rejectAction(_ sender: Any) {
    }
    @IBAction func acceptAction(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
