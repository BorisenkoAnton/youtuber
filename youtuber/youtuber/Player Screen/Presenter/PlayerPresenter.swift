//
//  PlayerPresenter.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class PlayerPresenter: PlayerPresenterDelegate {
    
    weak private var viewDelegate: PlayerViewControllerDelegate?
    
    
    func setViewDelegate(delegate: PlayerViewControllerDelegate) {
        
        self.viewDelegate = delegate
    }
    
    
    func getFullDescriptionForVideo(videoID: String) {
        
        // https://www.googleapis.com/youtube/v3/videos?part=snippet&id={VIDEO_ID}&key={YOUR_API_KEY}
        
        guard let path = Bundle.main.path(forResource: "APIConfig", ofType: "plist") else { return }
           
        let apiConfigAsDictionary = NSDictionary(contentsOfFile: path)
           
        let apiKey = apiConfigAsDictionary!["API key"]
           
        let urlString: String = ("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=\(videoID)&key=" + (apiKey as! String))//.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let url = URL(string: urlString) {
            NetworkManager.getData(url: url) { (data, response, error) in
                
                // Convert the JSON data to a dictionary
                do {
                    let resultDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
                    
                    // Get all search result items ("items" array).
                    let items: Array<Dictionary<String, Any>> = resultDictionary["items"] as! Array<Dictionary<String, Any>>
                    
                    let snippetDict = items[0]["snippet"] as! Dictionary<String, Any>
                    
                    let description = snippetDict["description"] as! String
                    
                    self.viewDelegate?.setDescription(description: description)
                } catch {
                    
                }
            }
        }
        
    }
}
