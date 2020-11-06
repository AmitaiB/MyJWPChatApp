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
    
    static func fillPosts(uid: String?, toId: String, completion: @escaping(_ result: Result<String, Error>) -> Void) {
        clearCurrentPosts()
        let allPosts = dbRef.child(L10n.DbPath.posts)
        print(allPosts)
        
        // a Uint? But this subscribes to
        let post = allPosts
            .queryOrdered(byChild: L10n.DbPath.uid)
            .queryEqual(toValue: FirebaseManager.currentUser?.uid)
            .observe(.childAdded)
                { snapshot in print(snapshot) }
        
        allPosts
            .queryOrdered(byChild: L10n.DbPath.uid)
            .queryEqual(toValue: FirebaseManager.currentUser?.uid)
            .observe(.childAdded) { (snapshot) in
                print(snapshot)
                
                if let result = snapshot.value as? [String: AnyObject] {
                    print(result.description)
                    if
                        let toIdCloud = result[L10n.DbPath.toId] as? String,
                        toIdCloud == toId,
                        let username = result[L10n.DbPath.username] as? String,
                        let text = result[L10n.DbPath.text] as? String
                    {
                        let post = Post(username: username, text: text, toId: toId)
                        PostManager.posts.append(post)
                    }
                }
            }
        completion(.success(""))
    }
    
    static func clearCurrentPosts() {
        posts = []
    }
}

struct Post {
    var username: String
    var text: String
    var toId: String
}
