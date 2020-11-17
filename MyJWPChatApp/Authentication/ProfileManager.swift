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
import CodableFirebase

class ProfileManager {
    static let dbRef = Database.database().reference()
    static let uid = Auth.auth().currentUser?.uid
    
    static var users = [User]()
    
    // Given the uid from Auth, give us a local user object
    static func getLocalUser(withUid uid: String?) -> User? {
        guard let uid = uid,
              let idx = users.firstIndex(where: {$0.uid == uid})
        else { return nil }
        
        return users[idx]
    }
    
    static func clearUsers() {
        users = []
    }
    
    static func fillUsers(completion: @escaping () -> Void) {
        clearUsers()
        dbRef.child(L10n.DbPath.users).observe(.childAdded) {
            print($0.description)
            
            guard let value = $0.value else { return }
            do {
                let user = try FirebaseDecoder().decode(User.self, from: value)
                users.append(user)
            }
            catch { print(error.localizedDescription) }
            
            completion()
        }
    }
}
