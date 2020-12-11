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
        
        NetworkConfiguration.configure()
    }
    
    
    func fetchVideos(searchingText: String) {

        let apiKey = NetworkConfiguration.shared.apiKey

        let urlString: String = ("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=\(searchingText)&type=video&key=\(apiKey ?? "")").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let url = URL(string: urlString) {
            NetworkManager.getData(url: url) { (data, response, error) in
                
                // Convert the JSON data to a dictionary
                do {
                    let resultDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
                    
                    // Get all search result items ("items" array).
                    let items: Array<Dictionary<String, Any>> = resultDictionary["items"] as! Array<Dictionary<String, Any>>
                    
                    var videosArray = Array<Dictionary<String, Any>>()
                    
                    for i in 0..<(items.count) {
                        let snippetDict = items[i]["snippet"] as! Dictionary<String, Any>
                        
                        var videoDetailsDict = Dictionary<String, Any>()
                        
                        videoDetailsDict["title"] = snippetDict["title"]
                        videoDetailsDict["publishedAt"] = self.formatDateString(dateString: snippetDict["publishedAt"] as! String)
                        videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<String, Any>)["default"] as! Dictionary<String, Any>)["url"]
                        videoDetailsDict["videoID"] = (items[i]["id"] as! Dictionary<String, Any>)["videoId"]
                        
                        videosArray.append(videoDetailsDict)
                    }
                    
                    self.viewDelegate?.setVideos(videos: videosArray)
                } catch {
                    let alert = AlertHelper.createAlert(title: "", message: "Data serializing error", preferredStyle: .alert)
                    
                    self.viewDelegate?.showAlert(alert: alert)
                }
            }
        }
    }
    
    
    func formatDateString(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: dateString)!
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        return dateFormatter.string(from: date)
    }
}
