//
//  JWPlayerViewController.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/2/20.
//

import UIKit

#warning("Make sure to set the channel ID")
fileprivate let CHANNEL_ID = "" // your channel ID here

class JWPlayerViewController: UIViewController {
    @IBOutlet weak var playerContainerView: UIView!
    var player: JWPlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // currently set to Bloomberg Live
        let placeholderURL = "https://cdn-videos.akamaized.net/btv/desktop/fastly/us/live/primary.m3u8"
        
        // Create the player as a playlist-of-one in order to enable use of the `load` API later.
        let itemConfig = JWConfig(contentURL: placeholderURL)
        let config = JWConfig()
        config.playlist = [JWPlaylistItem(config: itemConfig)]
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
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.makeNetworkCall()
    }
    
    /// Makes a network call to the JW Platform to get a json response, parses it for the status and
    /// unique id of the current broadcast, and loads it into the player.
    private func makeNetworkCall() {
        let endpointString = "https://live-cdn.jwplayer.com/live/channels/\(CHANNEL_ID).json"
        let endpointUrl = URL(string: endpointString)!
        
        let task = URLSession.shared
            .dataTask(with: endpointUrl) { (data, response, error) in
                if error != nil { /* amazing error handling here */ }
                
                if let mediaID = self.getMediaIdFromParsing(response: response, data: data)
                {
                    self.loadPlayer(withMediaID: mediaID)
                }
            }
        
        task.resume()
    }
            
    private func getMediaIdFromParsing(response: URLResponse?, data: Data?) -> String? {
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200,
            let jsonData = data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            let streamStatus = json["status"] as? String,
            streamStatus == "active",
            let mediaID = json["current_event"] as? String
        else { return nil }
        
        return mediaID
    }
    
    private func loadPlayer(withMediaID mediaID: String) {
        let urlString = "https://cdn.jwplayer.com/live/events/\(mediaID).m3u8"
        let newItemConfig = JWConfig(contentURL: urlString)
        newItemConfig.autostart = true
        DispatchQueue.main.async {
            self.player?.load([JWPlaylistItem(config: newItemConfig)])
        }
    }
}
