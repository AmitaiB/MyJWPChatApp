//
//  SettingsViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!

    var currentUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        profileImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UINavigationControllerDelegate {
    
}
