//
//  Post.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/6/20.
//

import Foundation

struct Post: Codable {
    var toId: String
    var text: String
    var ownerUid: String
    var ownerUsername: String?
}
