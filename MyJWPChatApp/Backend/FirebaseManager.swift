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
        
        Auth.auth().signIn(withEmail: email, password: password) {
            switch $0 {
                case .success(let data):
                    currentUser   = data.user.asLocalUserObj
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
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

extension Auth {
    /// Internally, calls the ObjC-backed version that passes back an Optional/Error, and maps it to a Result type.
    public func signIn(withEmail email: String,
                       password: String,
                       completion: ((Result<AuthDataResult, Error>) -> Void)?)
    {
        signIn(withEmail: email, password: password) { (data, error) in
            
            if let completion = completion {
                completion(self.resultFrom(response: data, error))
            }
        }
    }
    
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    private func resultFrom(response: AuthDataResult?, _ error: Error?) -> Result<AuthDataResult, Error> {
        if let response = response { return .success(response) }
        
        return .failure(error ?? LoginError.unknownError)
    }
    
    enum LoginError: Error { case unknownError }
}
