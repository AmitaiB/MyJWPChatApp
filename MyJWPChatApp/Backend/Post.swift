//
//  Post.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/6/20.
//

import Foundation

struct Post: Codable {
    var username: String
    var text: String
    var toId: String
    var uid: String?
}
