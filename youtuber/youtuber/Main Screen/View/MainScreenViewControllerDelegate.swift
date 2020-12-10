//
//  MainScreenViewControllerDelegate.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

protocol MainScreenViewControllerDelegate: class {
    
    func setMainScreenPresenterDelegate(delegate: MainScreenPresenterDelegate)
    func setVideos(videos: Array<Dictionary<String, Any>>)
    func showAlert(alert: UIAlertController)
}
