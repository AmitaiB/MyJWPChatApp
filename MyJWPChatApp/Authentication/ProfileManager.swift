//
//  ProfileManager.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/5/20.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ProfileManager {
    static let dbRef = Database.database().reference()
    static let uid = Auth.auth().currentUser?.uid
    
    static var users = [User]()
    
    static func getCurrentUser(uid: String) -> User? {
        if let idx = users.firstIndex(where: {$0.uid == uid}) {
            return users[idx]
        } else {
            return nil
        }
    }
    
    static func clearUsers() {
        users = []
    }
    
    static func fillUsers(completion: @escaping () -> Void) {
        clearUsers()
        dbRef.child(L10n.DbPath.users).observe(.childAdded) {
            print($0.description)
            if let result = $0.value as? [String: AnyObject] {
                let uid = result[L10n.DbPath.uid] as! String
                let username = result[L10n.DbPath.username] as! String
                let email = result[L10n.DbPath.email] as! String
                let profileImageUrl = result[L10n.DbPath.profileImageUrl] as! String
                
                let user = User(username: username,
                                email: email,
                                uid: uid,
                                profileImageUrl: profileImageUrl)
                
                users.append(user)
            }
            completion()
        }
    }
}
