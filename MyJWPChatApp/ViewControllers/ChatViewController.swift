//
//  ChatViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userInputField: UITextField!
    var selectedUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let selectedUserId = selectedUser?.uid else { return }
        PostManager.fillPosts(uid: FirebaseManager.currentUser?.uid,
                              toId: selectedUserId) {
            switch ($0) {
                case .success(let value):
                    print("\(value)")
                    
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
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard
            let username = selectedUser?.username,
            let message = userInputField.text,
            !message.isEmpty,
            let toId = selectedUser?.uid,
            let currentUid = FirebaseManager.currentUser?.uid
        else {return}
              
        PostManager.addPost(username: username,
                            text: message,
                            toId: toId,
                            fromId: currentUid)
        
        userInputField.clearField()
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

extension UITextField {
    func clearField() {
        text = nil
    }
}
