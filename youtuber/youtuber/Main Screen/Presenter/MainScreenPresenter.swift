//
//  MainScreenPresenter.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class MainScreenPresenter: MainScreenPresenterDelegate {
    
    weak private var viewDelegate: MainScreenViewControllerDelegate?
    
    
    func setViewDelegate(delegate: MainScreenViewControllerDelegate) {
        
        self.viewDelegate = delegate
    }
    
    
    func fetchVideos(urlString: String) {
        
        if let url = URL(string: urlString) {
            NetworkManager.getData(url: url) { (data, response, error) in
                
                // Convert the JSON data to a dictionary
                do {
                    let resultDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<NSObject, Any>
                    
                    // Get all search result items ("items" array).
                    let items: Array<Dictionary<NSObject, Any>> = resultDictionary["items" as NSObject] as! Array<Dictionary<NSObject, Any>>
                    
                    var videosArray = Array<Dictionary<NSObject, Any>>()
                    
                    for i in 0..<(items.count) {
                        let snippetDict = items[i]["snippet" as NSObject] as! Dictionary<NSObject, AnyObject>
                        
                        var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                        
                        videoDetailsDict["title" as NSObject] = snippetDict["title" as NSObject]
                        videoDetailsDict["thumbnail" as NSObject] = ((snippetDict["thumbnails" as NSObject] as! Dictionary<NSObject, AnyObject>)["default" as NSObject] as! Dictionary<NSObject, AnyObject>)["url" as NSObject]
                        videoDetailsDict["videoID" as NSObject] = (items[i]["id" as NSObject] as! Dictionary<NSObject, AnyObject>)["videoId" as NSObject]
                        
                        videosArray.append(videoDetailsDict)
                    }
                } catch {
                    
                }
            }
        }
    }
}
