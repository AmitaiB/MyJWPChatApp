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
    /// The logged in user.
    var currentUser: User? { didSet {
        syncLocalUserObjectToRemote(for: currentUser) }
    }
    
    // MARK: non-FirebaseUI login
    // On success, (1) signs in, (2) FirebaseManager saves the now logged in user locally
    func login(email: String,
                      password: String,
                      completion: @escaping (_ response: AuthDataResultType) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            let result = self.resultFrom(firebaseResponse: $0, $1)
            switch result {
                case .success(let data):
                    self.setLocalUser(from: data.user)
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
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
    
    func setLocalUser(from user: FirebaseAuth.User) {
        currentUser = user.asLocalUserObj
    }
    
    /**
     1. Creates a user in FireBase (Dashboard -> Users tab) (email, password, uid).
     2. Creates a `User` *object* from the created user (has a username).
     3. Login with the new credentials as normal.
     */
    func createAccount(email: String, password: String, username: String, completion: @escaping (_ result: AuthDataResultType) -> Void) {
        // 1. Create a Firebase user
        Auth.auth().createUser(withEmail: email, password: password) {
            let result = self.resultFrom(firebaseResponse: $0, $1)
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    // 2. Associate a username with that new user (?)
                    self.addSignedInUserToDB(username: username, email: email)
                    break
            }
        }
                
        // Login as the new user:
        login(email: email, password: password) {
            switch $0 {
                case .success(let response):
                    print("Login successful after account creation: \(response.user.description)")
                case .failure(let error):
                    print("Login unsuccessful after account creation: \(error.localizedDescription)")
            }
            completion($0)
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
    
    enum LoginError: Error { case unknownError }
    
    private func syncLocalUserObjectToRemote(for user: User?) {
        guard let user = user else { return }
        
        //sync with user object
        dbRef.child(L10n.DbPath.users)
            .queryOrdered(byChild: L10n.DbPath.uid)
            .queryEqual(toValue: user.uid)
            .observeSingleEvent(of: .value) {
                guard let value = $0.value else { return }
                do {
                    let user = try FirebaseDecoder().decode(User.self, from: value)
                    self.currentUser?.fillNils(from: user)
                }
                catch { print(error.localizedDescription) }
            }
    }
}

// MARK: - FUIAuthDelegate
extension FirebaseManager: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {

        let result = resultFrom(firebaseResponse: authDataResult, error)
        switch result {
            case .success(let data):
                setLocalUser(from: data.user)
                let user = data.user.asLocalUserObj
                addSignedInUserToDB(username: user.username, email: user.email)
                
            case .failure(let error):
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
