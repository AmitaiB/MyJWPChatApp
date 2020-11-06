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
    static var currentUserId = ""
    static var currentUser: User?
    
    static func login(email: String, password: String, completion: @escaping (_ success: Result<AuthDataResult, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else
            if let result = result {
//                currentUser   = result.user
                currentUserId = result.user.uid
                completion(.success(result))
            }
        }
    }
}
