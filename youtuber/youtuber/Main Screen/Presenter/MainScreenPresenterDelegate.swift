//
//  MainScreenPresenterDelegate.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol MainScreenPresenterDelegate {
    
    func setViewDelegate(delegate: MainScreenViewControllerDelegate)
    func fetchVideos(urlString: String)
}
