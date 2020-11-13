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
    static var currentUser: User? { didSet {
        syncUsernameAndImageUrlFromDB(for: currentUser) }
    }
    
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
     3. Login with the new credentials as normal.
     */
    static func createAccount(email: String, password: String, username: String, completion: @escaping (_ result: AuthDataResultType) -> Void) {
        // 1. Create a Firebase 'Authenticated User'
        Auth.auth().createUser(withEmail: email, password: password) {
            let result = resultFrom(firebaseResponse: $0, $1)
            
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    // 2. Create a user object in our Firebase db
                    addUser(from: data, username: username)
                    
                    // 3. Login as the new user:
                    login(email: email, password: password) {
                        switch $0 {
                            case .success(let response):
                                print("Login successful after account creation")
                            case .failure(let error):
                                print("Login unsuccessful after account creation: \(error.localizedDescription)")
                        }
                        completion($0)
                    }
            }
        }
    }
    
    static func addUser(from data: AuthDataResult, username: String?) {
        guard var user = data.user.asLocalUserObj else { return }
        user.username = username

        if let userData = try? FirebaseEncoder().encode(user) {
            dbRef
                .child(L10n.DbPath.users)
                .child(user.uid)
                .setValue(userData)
        }
    }
    
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    private static func resultFrom(firebaseResponse: AuthDataResult?, _ error: Error?) -> AuthDataResultType {
        if let response = firebaseResponse { return .success(response) }
        
        return .failure(error ?? LoginError.unknownError)
    }
    
    enum LoginError: Error { case unknownError }
    
    private static func syncUsernameAndImageUrlFromDB(for user: User?) {
        guard let user = user else { return }
        
        //sync with user object
        dbRef.child(L10n.DbPath.users)
            .queryOrdered(byChild: L10n.DbPath.uid)
            .queryEqual(toValue: user.uid)
            .observeSingleEvent(of: .value) {
                guard let value = $0.value else { return }
                do {
                    let user = try FirebaseDecoder().decode(User.self, from: value)

                    // overwrite local nil values
                    currentUser?.username = currentUser?.username ?? user.username
                    currentUser?.profileImageUrl = currentUser?.profileImageUrl ?? user.profileImageUrl
                    
                }
                catch { print(error.localizedDescription) }
            }
    }
}

extension FirebaseAuth.User {
    /// - returns: a `MyJWPChatApp.User` object.
    var asLocalUserObj: User? {
        User(uid: uid,
             email: email,
             username: uid,
             profileImageUrl: photoURL?.absoluteString)
    }
}
