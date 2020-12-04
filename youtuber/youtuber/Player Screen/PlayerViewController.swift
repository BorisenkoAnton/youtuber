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

    var videoID: String!
    
    @IBOutlet weak var player: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.player.load(withVideoId: videoID)
    }
}
