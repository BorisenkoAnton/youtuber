//
//  PlayerPresenterDelegate.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol PlayerPresenterDelegate {
    
    func setViewDelegate(delegate: PlayerViewControllerDelegate)
    func getVideoInfo(videoID: String)
    func getComments(videoID: String)
    func rateVideo(videoID: String, rating: String)
}
