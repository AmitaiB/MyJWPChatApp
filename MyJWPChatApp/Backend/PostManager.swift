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

import CodableFirebase

typealias PostResult = Result<Post, Error>

class PostManager {
    static let dbRef = Database.database().reference()
    static var posts = [Post]()
    
    // Fills the view controller with the existing conversation/threads
    static func fillPosts(uid: String?, toId: String, completion: @escaping(_ result: PostResult) -> Void) {
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
    
    // Well-named.
    static func addPost(username: String, text: String, toId: String, fromId: String) {
        guard !text.isEmpty else { return }
            
        let postData = try? FirebaseEncoder()
            .encode(Post(username: username,
                         text: text,
                         toId: toId,
                         uid: Auth.auth().currentUser?.uid))
        
        dbRef.child(L10n.DbPath.posts).childByAutoId().setValue(postData)
    }
        
    static func clearCurrentPosts() {
        posts = []
    }
}
