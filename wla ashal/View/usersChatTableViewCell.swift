//
//  usersChatTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 5/8/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class usersChatTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    var chat_id = ""
    var otherId = ""
    var otherName = ""
    var parent:usersChatViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.notificationView.ViewborderRound(border: 0.3, corner: 7.5)
        self.deleteView.isHidden = true
       
    }
    func swipeDetect(_ sender : UISwipeGestureRecognizer){
        self.deleteView.isHidden = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteAction(_ sender: Any) {
    }
}
