//
//  PlayerViewController.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import GoogleSignIn

class PlayerViewController: UIViewController {

    var playerPresenterDelegate: PlayerPresenterDelegate?
    var videoID: String!
    
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var viewsCountlabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var dislikesCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setPlayerPresenterDelegate(delegate: PlayerPresenter())
        
        self.playerPresenterDelegate?.setViewDelegate(delegate: self)
        
        self.playerPresenterDelegate?.getVideoInfo(videoID: self.videoID)
        
        self.player.load(withVideoId: videoID)
    }
}


extension PlayerViewController: PlayerViewControllerDelegate {
    
    func setPlayerPresenterDelegate(delegate: PlayerPresenterDelegate) {
        
        self.playerPresenterDelegate = delegate
    }
    
    
    func setVideoInfo(videoInfo: VideoInfo) {
        
        self.viewsCountlabel.text = (videoInfo.viewCount != nil) ? ("Views: " + String(videoInfo.viewCount!)) : ""
        self.likesCountLabel.text = (videoInfo.viewCount != nil) ? String(videoInfo.likeCount!) : ""
        self.dislikesCountLabel.text =  (videoInfo.viewCount != nil) ? String(videoInfo.dislikeCount!) : ""
        self.descriptionTextView.text = videoInfo.description
    }
}
