//
//  ChatTableViewCell.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/3/20.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet var messageTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageTextView.layer.cornerRadius = 10
        messageTextView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
