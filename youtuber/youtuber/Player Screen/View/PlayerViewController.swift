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
    var comments = [CommentInfo]()
    
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var viewsCountlabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var dislikesCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var commentsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setPlayerPresenterDelegate(delegate: PlayerPresenter())
        
        self.playerPresenterDelegate?.setViewDelegate(delegate: self)
        
        self.player.load(withVideoId: videoID)
        
        self.playerPresenterDelegate?.getVideoInfo(videoID: self.videoID)
        
        self.playerPresenterDelegate?.getComments(videoID: self.videoID)
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
    
    
    func setComments(comments: [CommentInfo]) {
        
        self.comments = comments
        
        self.commentsTable.reloadData()
    }
}


extension PlayerViewController: UITableViewDelegate {}


extension PlayerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentsTableViewCell
        
        let comment = self.comments[indexPath.row]
        
        cell.commentAuthorNameLabel.text = comment.author
        cell.commentPublicationDateLabel.text = comment.date
        cell.commentTextTextView.text = comment.text
        
        return cell
    }
}
