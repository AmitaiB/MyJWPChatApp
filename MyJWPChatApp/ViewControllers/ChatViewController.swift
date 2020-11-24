//
//  ChatViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userInputField: UITextField!
    var selectedUser: User?
    
    var cellHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableView.automaticDimension
        
        userInputField.inputView?.backgroundColor = .systemGroupedBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let selectedUserId = selectedUser?.uid else { return }
        PostManager.fetchPosts(ownerUid: FirebaseManager.shared.currentUser?.uid,
                              toId: selectedUserId) {
            switch ($0) {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    print("\(value)")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
            let currentUid = FirebaseManager.shared.currentUser?.uid
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
        cellHeight = cell.messageTextView.contentSize.height
        
        let post = PostManager.posts[indexPath.row]
        cell.messageTextView.text = post.text

        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // ????
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.setContentOffset(currentOffset, animated: false)
    }
}

extension UITextField {
    func clearField() {
        text = nil
    }
}
