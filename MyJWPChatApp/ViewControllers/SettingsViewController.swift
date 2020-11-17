//
//  SettingsViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!

    var currentUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func getPhotoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
