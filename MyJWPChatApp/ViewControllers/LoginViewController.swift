//
//  ViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/1/20.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard
            let email = emailField.text?.trimmingCharacters(in: .whitespaces),
            let password = passwordField.text?.trimmingCharacters(in: .whitespaces)
        else { return }
        
//        let email    = L10n.Mock.User.Amitai.email
//        let password = L10n.Mock.User.Amitai.password
        
        FirebaseManager.login(email: email,
                              password: password) {
            switch $0 {
                case .success(let dataResult):
                    self.perform(segue: StoryboardSegue.Login.showProfileSegueID)
                    print("SUCCESS: \(dataResult.description)")
                case .failure(let error):
                    print("FAILURE with Error: \(error.localizedDescription)")
            }
        }
    }
}

