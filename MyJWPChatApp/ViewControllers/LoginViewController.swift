//
//  ViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/1/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var isLoggedIn: Bool {Auth.auth().currentUser != nil}
    var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showMainSceneIfLoggedIn()
        
        // Respond to Social Login
        authListener = Auth.auth().addStateDidChangeListener { (_, _) in
            self.dismiss(animated: true, completion: nil)
            self.showMainSceneIfLoggedIn()
        }
    }
    
    deinit {
        authListener.map {
            Auth.auth().removeStateDidChangeListener($0)
        }
    }

    // Login with email/password
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard
            let email    = emailField.text?.lowerTrimmed(),
            let password = passwordField.text?.lowerTrimmed()
        else { return }

        FirebaseManager.shared.login(email: email, password: password) {
            switch $0 {
                case .failure(let error): print("Error: \(error)")
                case .success(_): break // authListener handles case
            }
        }
    }


    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        guard
            let email    = emailField.text,
            let password = passwordField.text,
            let username = usernameField.text
        else { print("Invalid text field input(s)"); return }
        
        FirebaseManager.shared.createAccount(email: email,
                                             password: password,
                                             username: username) { _ in
            // authListener handles case
        }
    }

    @IBAction func socialLoginButtonTapped(_ sender: UIButton) {
        //fbUI
        guard let authUIVC = FirebaseManager.shared.getFUIAuthViewController() else { return }
        present(authUIVC, animated: true, completion: nil)
    }
    
    private func showMainSceneIfLoggedIn() {
        if isLoggedIn {
            self.perform(segue: StoryboardSegue.Login.showMainSegueID)
        }
    }
}

extension String {
    /// Whitespace trimmed, and lowercased
    func lowerTrimmed() -> String {trimmingCharacters(in: .whitespacesAndNewlines).lowercased()}
}
