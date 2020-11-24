//
//  ProfileTableViewCell.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/11/20.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        adjustImageToProfileStyle()
    }
    
    private func adjustImageToProfileStyle() {
        profileImageView.layer.cornerRadius = 15
        profileImageView.layer.masksToBounds = true
    }
}
