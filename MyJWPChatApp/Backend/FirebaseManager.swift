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

import CodableFirebase

typealias AuthDataResultType = Result<AuthDataResult, Error>

class FirebaseManager {
    static let dbRef = Database.database().reference()
    /// The "logged in" user.
    static var currentUser: User?
    
    // On success, (1) signs in, (2) FirebaseManager saves the now logged in user locally
    static func login(email: String,
                      password: String,
                      completion: @escaping (_ response: AuthDataResultType) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) {
            let result = resultFrom(firebaseResponse: $0, $1)
            switch result {
                case .success(let data):
                    currentUser   = data.user.asLocalUserObj
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }        
    }
    
    /**
     1. Creates a user in FireBase (Dashboard -> Users tab) (email, password, uid).
     2. Creates a `User` *object* from the created user (has a username).
     3. Login with as normal.
     */
    static func createAccount(email: String, password: String, username: String, completion: @escaping (_ result: AuthDataResultType) -> Void) {
        // 1. Create a Firebase user
        Auth.auth().createUser(withEmail: email, password: password) {
            let result = resultFrom(firebaseResponse: $0, $1)
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    break
            }
        }
        
        // 2. Associate a username with that new user (?)
        addUser(username: username, email: email)
        
        // Login as the new user:
        login(email: email, password: password) {
            switch $0 {
                case .success(let response):
                    print("Login successful after account creation")
                case .failure(let error):
                    print("Login unsuccessful after account creation")
            }
            completion($0)
        }
        
    }
    
    static func addUser(username: String, email: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let user = User(username: username,
                        email: email,
                        uid: uid,
                        profileImageUrl: "")
        
        if let userData = try? FirebaseEncoder().encode(user) {
            dbRef
                .child(L10n.DbPath.users)
                .child(uid)
                .setValue(userData)
        }
    }
    
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    private static func resultFrom(firebaseResponse: AuthDataResult?, _ error: Error?) -> AuthDataResultType {
        if let response = firebaseResponse { return .success(response) }
        
        return .failure(error ?? LoginError.unknownError)
    }
    
    enum LoginError: Error { case unknownError }
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
