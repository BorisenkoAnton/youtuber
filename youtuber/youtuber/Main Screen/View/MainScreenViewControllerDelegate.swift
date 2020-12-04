//
//  MainScreenViewControllerDelegate.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol MainScreenViewControllerDelegate: class {
    
    func setMainScreenPresenterDelegate(delegate: MainScreenPresenterDelegate)
    func setVideos(videos: Array<Dictionary<NSObject, Any>>)
}
