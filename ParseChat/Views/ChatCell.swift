//
//  ChatCell.swift
//  ParseChat
//
//  Created by Samuel on 2/16/18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleView.layer.cornerRadius = 10
        bubbleView.clipsToBounds = true
        self.selectionStyle = .none
//        let insets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
//        message.drawText(in: UIEdgeInsetsInsetRect(message.frame, insets))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
