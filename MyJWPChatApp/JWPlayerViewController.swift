//
//  JWPlayerViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

class JWPlayerViewController: UIViewController {
    @IBOutlet weak var playerContainerView: UIView!
    var player: JWPlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = JWConfig(contentURL: "http://content.bitsontherun.com/videos/3XnJSIm4-injeKYZS.mp4")
        player = JWPlayerController(config: config)
        
        title = "JWP SDK ver: \(JWPlayerController.sdkVersionToMinor())"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let playerView = player?.view {
            playerContainerView.addSubview(playerView)
            playerView.constrainToSuperview()
        }
    }
}
