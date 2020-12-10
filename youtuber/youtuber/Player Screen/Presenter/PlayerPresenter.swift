//
//  PlayerPresenter.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation
import GoogleSignIn

class PlayerPresenter: PlayerPresenterDelegate {
    
    weak private var viewDelegate: PlayerViewControllerDelegate?
    
    
    func setViewDelegate(delegate: PlayerViewControllerDelegate) {
        
        self.viewDelegate = delegate
    }
    
    
    func getVideoInfo(videoID: String){
        
        if let apiKey = NetworkConfiguration.shared.apiKey {
            let urlString: String = "https://www.googleapis.com/youtube/v3/videos?part=snippet&part=statistics&id=\(videoID)&key=\(apiKey)"
            
            if let url = URL(string: urlString) {
                NetworkManager.getData(url: url) { (data, response, error) in
                    
                    do {
                        let resultDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
                        
                        let items: Array<Dictionary<String, Any>> = resultDictionary["items"] as! Array<Dictionary<String, Any>>
                        
                        let snippetDict = items[0]["snippet"] as! Dictionary<String, Any>
                        let statsDict = items[0]["statistics"] as! Dictionary<String, Any>

                        let description = snippetDict["description"] as! String
                        let viewCount = UInt(statsDict["viewCount"] as! String)
                        let likeCount = UInt(statsDict["likeCount"] as! String)
                        let dislikeCount = UInt(statsDict["dislikeCount"] as! String)

                        let videoInfo = VideoInfo(description: description, viewCount: viewCount, likeCount: likeCount, dislikeCount: dislikeCount)

                        self.viewDelegate?.setVideoInfo(videoInfo: videoInfo)
                    } catch {
                        let alert = AlertHelper.createAlert(title: "", message: "Data serializing error", preferredStyle: .alert)
                        
                        self.viewDelegate?.showAlert(alert: alert)
                    }
                }
            }
        }
    }
    
    
    func getComments(videoID: String) {
        
        if  GIDSignIn.sharedInstance()?.currentUser == nil {
            let alert = AlertHelper.createAlert(title: "Unable to get comments", message: "To view comments log in, please", preferredStyle: .alert)
            
            self.viewDelegate?.showAlert(alert: alert)
        } else if (GIDSignIn.sharedInstance()?.currentUser.authentication.accessTokenExpirationDate)! < Date() {
            let alert = AlertHelper.createAlert(title: "Unable to get comments", message: "Access token expired. To view comments re-login, please", preferredStyle: .alert)
            
            self.viewDelegate?.showAlert(alert: alert)
        } else {
            if let apiKey = NetworkConfiguration.shared.apiKey {
                let urlString = "https://www.googleapis.com/youtube/v3/commentThreads?part=snippet&videoId=\(videoID)&maxResults=50&key=\(apiKey)"
                
                if let url = URL(string: urlString) {
                    NetworkManager.getData(url: url) { (data, response, error) in
                        
                        do {
                            let resultDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>

                            let items: Array<Dictionary<String, Any>> = resultDictionary["items"] as! Array<Dictionary<String, Any>>
                            
                            var comments = [CommentInfo]()
                            
                            for item in items {
                                let snippetDict = item["snippet"] as! Dictionary<String, Any>
                                let topLevelcomment = snippetDict["topLevelComment"] as! Dictionary<String, Any>
                                let topLevelcommentSnippet = topLevelcomment["snippet"] as! Dictionary<String, Any>

                                let author = topLevelcommentSnippet["authorDisplayName"] as! String
                                let date = topLevelcommentSnippet["publishedAt"] as! String
                                let text = topLevelcommentSnippet["textDisplay"] as! String

                                let comment = CommentInfo(author: author, date: date, text: text)

                                comments.append(comment)
                            }
                            
                            self.viewDelegate?.setComments(comments: comments)
                            
                        } catch {
                            let alert = AlertHelper.createAlert(title: "", message: "Data serializing error", preferredStyle: .alert)
                            
                            self.viewDelegate?.showAlert(alert: alert)
                        }
                    }
                }
            }
        }
    }

}
