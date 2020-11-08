//
//  PostManager.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/3/20.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PostManager {
    static let dbRef = Database.database().reference()
    static var posts = [Post]()
    
    static func fillPosts(uid: String?,
                          toId: String,
                          completion: @escaping(_ result: Result<Post, Error>) -> Void) {
        clearCurrentPosts()
        
        dbRef
            .child(L10n.DbPath.posts) // only posts
            .queryOrdered(byChild: L10n.DbPath.uid) // uniq by uid
            .queryEqual(toValue: FirebaseManager.currentUser?.uid) // this user's posts
            .observe(.childAdded) {
                guard let postValue = $0.value else { return }
                
                print("postValue in 'fillPosts': \($0.debugDescription)")
                
                do {
                    let newPost = try Post(decodeFrom: postValue)
                    PostManager.posts.append(newPost)
                    completion(.success(newPost))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
    
    static func clearCurrentPosts() {
        posts = []
    }
}
