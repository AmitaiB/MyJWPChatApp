//
//  AppLaunchViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/14/20.
//

import UIKit
import Firebase

class AppLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.presentedViewController.map { _ in
                self.dismiss(animated: true, completion: nil)
            }
            let requiredSegue: StoryboardSegue.Login =
                (user == nil) ? .showLoginSegueID : .showMainSegueID
            
            self.perform(segue: requiredSegue)
        }
    }
}
