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
    private static var cachedUsers = [String: User]()
    static func getCachedUser(forId uid: String?) -> User? {
        guard let uid = uid else { return nil }
        return cachedUsers[uid]
    }
    static func cache(user: User) {
        cachedUsers[user.uid] = user
    }
    
    static var users: [User] {Array(cachedUsers.values)}
    
    
    static func fillUsers(completion: @escaping () -> Void) {
        dbRef.child(L10n.DbPath.users)
            .observe(.childAdded)
            {
                guard let userData = $0.value else { return }
                do {
                    let user = try FirebaseDecoder().decode(User.self, from: userData)
                    self.cache(user: user)
                }
                catch { print(error.localizedDescription) }
                
                completion()
            }
    }
}
