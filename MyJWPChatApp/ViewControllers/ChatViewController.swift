//
//  ChatViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var selectedUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PostManager.fillPosts(uid: FirebaseManager.currentUser?.uid,
                              toId: (selectedUser?.uid)!) {
            switch ($0) {
                case .success(let value):
                    print("")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PostManager.clearCurrentPosts()
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PostManager.posts.count
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
