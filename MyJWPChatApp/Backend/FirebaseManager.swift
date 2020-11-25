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
import FirebaseUI

import CodableFirebase

typealias AuthDataResultType = Result<AuthDataResult, Error>

class FirebaseManager: NSObject {
    // MARK: Singleton - db management
    static var shared = FirebaseManager()
    private override init() {
        super.init()
    }
    
    let dbRef = Database.database().reference()
    
    // MARK: - State properties
    /// The logged in user (should be cached).    
    var currentUser: User? {
        ProfileManager.getCachedUser(forId: currentUserID)
    }
    var currentUserID: String? { Auth.auth().currentUser?.uid }
    
    // MARK: non-FirebaseUI login
    // On success, (1) signs in, (2) FirebaseManager saves the now logged in user locally
    func login(email: String,
                      password: String,
                      completion: @escaping (_ response: AuthDataResultType) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            let result = self.resultFrom(firebaseResponse: $0, $1)
            completion(result)
        }
    }
    
    // MARK: - FirebaseUI login
    func getFUIAuthViewController() -> UINavigationController? {
        let authUI = FUIAuth.defaultAuthUI()

        // Add additional sign in providers here
        authUI?.providers = [
            FUIGoogleAuth(),
            FUIOAuth.appleAuthProvider(),
        ]
        authUI?.delegate = self

        return authUI?.authViewController()
    }
    
    
    // MARK: Common methods
    /**
     1. Creates a user in FireBase (Dashboard -> Users tab) (email, password, uid).
     2. Creates a `User` *object* from the created user (has a username).
     */
    func createAccount(email: String, password: String, username: String, completion: @escaping (_ result: AuthDataResultType) -> Void) {
        // 1. Create a Firebase user
        Auth.auth().createUser(withEmail: email, password: password) {
            let result = self.resultFrom(firebaseResponse: $0, $1)
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(_):
                    self.addSignedInUserToDB(username: username, email: email)
            }
        }                
    }
    
    func addSignedInUserToDB(username: String?, email: String?) {
        guard let uid = currentUser?.uid else { return }

        let user = User(uid: uid,
                        email: email,
                        username: username,
                        profileImageUrl: nil)
        
        if let userData = try? FirebaseEncoder().encode(user) {
            dbRef
                .child(L10n.DbPath.users)
                .child(user.uid)
                .setValue(userData)
        }
    }
    
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    fileprivate func resultFrom(firebaseResponse: AuthDataResult?, _ error: Error?) -> AuthDataResultType {
        if let response = firebaseResponse { return .success(response) }
        
        return .failure(error ?? FirebaseError.unknownError("login error"))
    }
}

// MARK: - FUIAuthDelegate
extension FirebaseManager: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            print("ERROR in \(#function): ", error.localizedDescription)
        }
    }
}

extension FirebaseAuth.User {
    /// - returns: a `MyJWPChatApp.User` object.
    var asLocalUserObj: User {
        User(uid: uid,
             email: email,
             username: email,
             profileImageUrl: photoURL?.absoluteString)
    }
}

public enum FirebaseError: Error {
    case unknownError(String)
}
