//
//  ProfileTableViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit
import SDWebImage

class ProfileTableViewController: UITableViewController {
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.reloadData()
        ProfileManager.fillUsers {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileManager.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: L10n.ReuseID.profileCell, for: indexPath) as! ProfileTableViewCell

        let user = ProfileManager.users[indexPath.row]
        cell.profileNameLabel.text = user.username

        let imageUrl = user.profileImageUrl ?? user.gravatarImageUrl ?? ""
        cell.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "icons8-name"))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = ProfileManager.users[indexPath.row]
        perform(segue: StoryboardSegue.Main.showChatViewSegueID)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch StoryboardSegue.Main(segue) {
            case .showChatViewSegueID:
                let chatVC = segue.destination as? ChatViewController
                chatVC?.selectedUser = selectedUser

            case .showSettingsSegueID:
                let settingsVC = segue.destination as? SettingsViewController
                settingsVC?.currentUser = ProfileManager.getLocalUser(withUid: FirebaseManager.currentUser?.uid)
            case .none:
                break
        }        
    }
}
