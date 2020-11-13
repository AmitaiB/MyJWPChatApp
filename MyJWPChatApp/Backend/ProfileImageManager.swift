//
//  ProfileImageManager.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/12/20.
//

import Foundation
import FirebaseStorage

class ProfileImageManager {
    static func uploadProfilePhoto(_ profileImage: UIImage, forUser user: User) {
        uploadProfilePhoto(profileImage) { (downloadResult) in
            switch downloadResult {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let url):
                    // update the local representation of the user
                    user.profileImageUrl = url.absoluteString
                    
                    // update this user's remote store
                    FirebaseManager.dbRef
                        .child(L10n.DbPath.users)
                        .child(user.uid)
                        .updateChildValues([L10n.DbPath.profileImageUrl: url.absoluteString])
            }
        }
    }
    
    static func uploadProfilePhoto(_ profileImage: UIImage, completion: @escaping ((DownloadURLResult) -> Void)) {
        let profileImageRef = Storage.storage().reference()
            .child(L10n.DbPath.profileImages)
            .child("\(UUID().uuidString).jpg")
        
        
        // early-exit
        let imageCompressionError = NSError(domain: "Image Compression Error", code: -1, userInfo: nil)
        guard let imageData = profileImage.jpegData(compressionQuality: 0.25)
        else { completion(.failure(imageCompressionError)); return}
        
        profileImageRef.putData(imageData, metadata: nil) {
            let metadataResponse = resultFrom(metadataResponse: $0, $1)
            
            switch metadataResponse {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let metadata):
                    metadata.storageReference?.downloadURL() {
                        let result = resultFrom(urlResponse: $0, $1)
                        completion(result)
                    }
            }
        }
    }

    // MARK: - Result-type's bridging functions
    
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    private static func resultFrom(urlResponse: URL?, _ error: Error?) -> DownloadURLResult {
        if let response = urlResponse { return .success(response) }
        
        return .failure(error ?? FirebaseError.unknownError("downloadURL retrieval error"))
    }
    
    typealias DownloadURLResult = Result<URL, Error>
    

    
    /// Maps the Firebase Optional/Error response to a Swift 4+ Result type (`Result<AuthDataResult, Error>`).
    private static func resultFrom(metadataResponse: StorageMetadata?, _ error: Error?) -> StorageMetadataResult {
        if let response = metadataResponse { return .success(response) }
        
        return .failure(error ?? FirebaseError.unknownError("metadata error"))
    }
    
    typealias StorageMetadataResult = Result<StorageMetadata, Error>
    

    
    /**
     Replaced by SDWebImage.
     */
//    static func fetchImage(for user: User?) -> UIImage? {
//        guard
//            let user = user,
//            let imageUrlString = user.profileImageUrl,
//            let imageUrl = URL(string: imageUrlString),
//            let imageData = try? Data(contentsOf: imageUrl)
//        else { return nil }
//
//        return UIImage(data: imageData)
//    }
}
