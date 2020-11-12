//
//  User.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/5/20.
//

import Foundation

struct User: Codable {
    // Properties shared with FirebaseAuth.User
    var uid: String
    var email: String?

    // Properties unique to our user objects
    var username: String?
    var profileImageUrl: String?
}
