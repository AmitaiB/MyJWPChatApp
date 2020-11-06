//
//  ChatViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PostManager.clearCurrentPosts()
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: L10n.ReuseID.chatCell, for: indexPath) as! ChatTableViewCell
        
        let messageText = cell.messageTextView!
//        messageText.delegate = self
        let post = PostManager.posts[indexPath.row]
        messageText.text = post.text

        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    
}
