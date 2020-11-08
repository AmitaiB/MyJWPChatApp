//
//  FirebaseManager.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/3/20.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FirebaseManager {
    static let dbRef = Database.database().reference()
    /// The "logged in" user.
    static var currentUser: User?
    
    static func login(email: String, password: String, completion: @escaping (_ success: Result<AuthDataResult, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else
            if let authResult = result {
                currentUser   = authResult.user.asLocalUserObj
                completion(.success(authResult))
            }
        }
    }
}

extension FirebaseAuth.User {
    /// - returns: a `MyJWPChatApp.User` object.
    var asLocalUserObj: User? {
        User(username: displayName ?? "username not set",
             email: email ?? "email not set",
             uid: uid,
             profileImageUrl: photoURL?.absoluteString ?? "profile image url not set")
    }
}
