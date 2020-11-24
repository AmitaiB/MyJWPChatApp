//
//  SettingsViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    /// `FirebaseManager.shared.currentUser`
    var currentUser: User? {FirebaseManager.shared.currentUser}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfileImage()
    }

    private func setupProfileImage() {
        profileImageView.layer.cornerRadius  = 15
        profileImageView.layer.masksToBounds = true
        
        guard let urlStr = currentUser?.profileImageUrl,
              let url = URL(string: urlStr)
        else { return }
        profileImageView.sd_setImage(with: url,
                                     placeholderImage: #imageLiteral(resourceName: "icons8-name"),
                                     options: [.continueInBackground],
                                     context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayNameLabel.text = currentUser?.username
    }
    
    @IBAction func getPhotoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        uploadPhoto()
    }
    
    func uploadPhoto() {
        guard let profileImage = profileImageView.image else { return }
        currentUser?.uploadProfilePhoto(profileImage)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch { print(error.localizedDescription) }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        profileImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UINavigationControllerDelegate {
    
}
