//
//  ViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/1/20.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        //fbUI
        guard let authUIVC = FirebaseManager.shared.fbUiAuthVC else { return }
        present(authUIVC, animated: true, completion: nil)

//        guard
//            let email = emailField.text?.trimmingCharacters(in: .whitespaces),
//            let password = passwordField.text?.trimmingCharacters(in: .whitespaces)
//        else { return }
//
//        FirebaseManager.login(email: email,
//                              password: password) {
//            switch $0 {
//                case .success(let dataResult):
//                    self.perform(segue: StoryboardSegue.Login.showMainSegueID)
//                    print("SUCCESS: \(dataResult.description)")
//                case .failure(let error):
//                    print("FAILURE with Error: \(error.localizedDescription)")
//            }
//        }
    }


    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        guard
            let email = emailField.text,
            let password = passwordField.text,
            let username = usernameField.text
        else { print("Create New Account not attempted"); return }
        
        FirebaseManager.shared.createAccount(email: email,
                                      password: password,
                                      username: username) { _ in
            self.perform(segue: StoryboardSegue.Login.showMainSegueID)
        }
    }
}

