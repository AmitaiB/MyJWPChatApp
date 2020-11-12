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
    static func fetchPosts(ownerUid: String?, toId: String, completion: @escaping(_ result: PostResult) -> Void) {
        clearCurrentPosts()
        
        dbRef
            .child(L10n.DbPath.posts) // only posts
            .queryOrdered(byChild: L10n.DbPath.ownerUid) // performance
            .queryEqual(toValue: ownerUid) // this user's posts
            .observe(.childAdded) {
                guard let postData = $0.value else { return }
                
                print("postValue in 'fillPosts': \($0.debugDescription)")
                
                do {
                    let newPost = try FirebaseDecoder().decode(Post.self, from: postData)

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
        guard !text.isEmpty,
              let currentUid = FirebaseManager.currentUser?.uid
              else { return }
            
        let encodablePost = Post(toId: toId, text: text, ownerUid: currentUid, ownerUsername: username)
        
        let postData = try? FirebaseEncoder().encode(encodablePost)
        
        dbRef.child(L10n.DbPath.posts).childByAutoId().setValue(postData)
    }
        
    static func clearCurrentPosts() {
        posts = []
    }
}
