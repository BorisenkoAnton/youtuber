//
//  PlayerViewControllerDelegate.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol PlayerViewControllerDelegate: class {
    
    func setPlayerPresenterDelegate(delegate: PlayerPresenterDelegate)
    func setVideoInfo(videoInfo: VideoInfo)
    func setComments(comments: [CommentInfo])
}
