//
//  User.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/5/20.
//

import Foundation
import CryptoKit

class User: Codable {
    // Properties shared with FirebaseAuth.User
    var uid: String
    var email: String?

    // Properties unique to our user objects
    var username: String?
    var profileImageUrl: String?
    
    var gravatarImageUrl: String? {
        guard let emailData = email?.data(using: .utf8) else { return nil }
        let emailHash = Insecure.MD5.hash(data: emailData)
        let unheraldedHash = "\(emailHash)".dropFirst(L10n.md5PrefixToTrim.count)
        return L10n.gravatarBaseURL + unheraldedHash
    }
    
    init(uid: String, email: String?, username: String?, profileImageUrl: String?) {
        self.uid             = uid
        self.email           = email
        self.username        = username
        self.profileImageUrl = profileImageUrl
    }
}
