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
        
        let config = JWConfig(contentURL: "https://cdn-videos.akamaized.net/btv/desktop/fastly/us/live/primary.m3u8")
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
