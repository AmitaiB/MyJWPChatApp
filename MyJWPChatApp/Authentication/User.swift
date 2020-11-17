//
//  User.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/5/20.
//

import Foundation
import CryptoKit
import Firebase

class User: Codable {
    // Properties shared with FirebaseAuth.User
    var uid: String
    var email: String?

    // Properties unique to our user objects
    var username: String?
    var profileImageUrl: String?
    
    var gravatarImageUrl: String? { getGravatarImageUrl() }
    
    init(uid: String, email: String?, username: String?, profileImageUrl: String?) {
        self.uid             = uid
        self.email           = email
        self.username        = username
        self.profileImageUrl = profileImageUrl
    }
    
    /// Assigns any nil values to the source's value
    mutating func fillNils(from srcUser: User) {
        email           = email ?? srcUser.email
        username        = username ?? srcUser.username
        profileImageUrl = profileImageUrl ?? srcUser.profileImageUrl
    }
}

// MARK: - Profile Image functions
extension User {
    func uploadProfilePhoto(_ profileImage: UIImage) {
        let profileImageRef = Storage.storage().reference()
            .child(L10n.DbPath.profileImages)
            .child("\(UUID().uuidString).jpg")

        // early-exit
        guard let imageData = profileImage.jpegData(compressionQuality: 0.25)
        else {
            print("image compression failure")
            return
        }
        
        profileImageRef.putData(imageData, metadata: nil) {
            let metadataResponse = self.resultFrom(metadataResponse: $0, $1)
            switch metadataResponse {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(_):
                    // Get the image's download url
                    profileImageRef.downloadURL() {
                        let result = self.resultFrom(urlResponse: $0, $1)
                        self.handleImageDownloadResult(result)
                    }
            }
        }
    }

    private func handleImageDownloadResult(_ result: DownloadURLResult) {
        switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let url):
//                if self.profileImageUrl.isNilOrEmpty
//                {
                    self.updateProfileImageURL(url: url)
//                }
        }
    }
    
    private func updateProfileImageURL(url: URL) {
        // update the local representation of the user
        profileImageUrl = url.absoluteString
        
        // update this user's remote store
        FirebaseManager.dbRef
            .child(L10n.DbPath.users)
            .child(uid)
            .updateChildValues([L10n.DbPath.profileImageUrl: url.absoluteString])
    }


    // MARK: - Result-type's bridging functions
    
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    private func resultFrom(urlResponse: URL?, _ error: Error?) -> DownloadURLResult {
        if let response = urlResponse { return .success(response) }
        
        return .failure(error ?? FirebaseError.unknownError("downloadURL retrieval error"))
    }
    
    typealias DownloadURLResult = Result<URL, Error>
    
    // unused
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    private func resultFrom(metadataResponse: StorageMetadata?, _ error: Error?) -> StorageMetadataResult {
        if let response = metadataResponse { return .success(response) }
        
        return .failure(error ?? FirebaseError.unknownError("metadata error"))
    }
    
    typealias StorageMetadataResult = Result<StorageMetadata, Error>

    
    // Fallback; currently using SDWebImage
//    func fetchProfileImage() -> UIImage? {
//        guard
//            let imageUrl = profileImageUrl,
//            let url = URL(string: imageUrl),
//            let imageData = try? Data(contentsOf: url)
//        else { return nil }
//
//        return UIImage(data: imageData)
//    }
    
    /// Generates the Gravatar thumbnail's url from the User's email address.
    fileprivate func getGravatarImageUrl() -> String? {
        guard let emailData = email?.data(using: .utf8) else { return nil }
        let emailHash = Insecure.MD5.hash(data: emailData)
        // The string produced has a prefix that needs to go
        let unheraldedHash = "\(emailHash)".dropFirst(L10n.md5PrefixToTrim.count)
        return L10n.gravatarBaseURL + unheraldedHash
    }
}
