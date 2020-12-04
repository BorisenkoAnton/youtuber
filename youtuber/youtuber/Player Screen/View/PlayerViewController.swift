//
//  PlayerViewController.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController {

    var playerPresenterDelegate: PlayerPresenterDelegate?
    var videoID: String!
    
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setPlayerPresenterDelegate(delegate: PlayerPresenter())
        
        self.playerPresenterDelegate?.setViewDelegate(delegate: self)
        
        self.playerPresenterDelegate?.getFullDescriptionForVideo(videoID: self.videoID)
        
        self.player.load(withVideoId: videoID)
    }
}


extension PlayerViewController: PlayerViewControllerDelegate {
    
    func setPlayerPresenterDelegate(delegate: PlayerPresenterDelegate) {
        
        self.playerPresenterDelegate = delegate
    }
    
    
    func setDescription(description: String) {
        
        self.videoDescriptionLabel.text = description
        
        self.videoDescriptionLabel.sizeToFit()
    }
}
