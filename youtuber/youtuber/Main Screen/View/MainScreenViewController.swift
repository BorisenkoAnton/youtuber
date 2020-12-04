//
//  ViewController.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    private var videosArray = Array<Dictionary<NSObject, Any>>()

    var mainScreenPresenterDelegate: MainScreenPresenterDelegate?
    var selectedVideoIndex: Int?
    
    @IBOutlet weak var searchingtextField: UITextField!
    @IBOutlet weak var videosTable: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setMainScreenPresenterDelegate(delegate: MainScreenPresenter())
        self.mainScreenPresenterDelegate?.setViewDelegate(delegate: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "idPlayerSegue" && selectedVideoIndex != nil {
            let playerViewController = segue.destination as! PlayerViewController
            playerViewController.videoID = (videosArray[selectedVideoIndex!]["videoID" as NSObject] as! String)
        }
    }
}


extension MainScreenViewController: MainScreenViewControllerDelegate {
    
    func setMainScreenPresenterDelegate(delegate: MainScreenPresenterDelegate) {
        
        self.mainScreenPresenterDelegate = delegate
    }
    
    
    func setVideos(videos: Array<Dictionary<NSObject, Any>>) {
        
        self.videosArray = videos
        
        self.videosTable.reloadData()
    }
}


extension MainScreenViewController: UITableViewDelegate {}


extension MainScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.videosArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideosTableViewCell
        
        let videoDetails = videosArray[indexPath.row]
        
        cell.videoNameLabel.text = videoDetails["title" as NSObject] as? String
        cell.thumbnailImageView.image = UIImage(data: NSData(contentsOf: NSURL(string: (videoDetails["thumbnail" as NSObject] as? String)!)! as URL)! as Data)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedVideoIndex = indexPath.row
        
        performSegue(withIdentifier: "idPlayerSegue", sender: self)
    }
}


extension MainScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        if self.searchingtextField.text != nil {
            
            guard let path = Bundle.main.path(forResource: "APIConfig", ofType: "plist") else { return false }
            
            let apiConfigAsDictionary = NSDictionary(contentsOfFile: path)
            
            let apiKey = apiConfigAsDictionary!["API key"]
            
            videosArray.removeAll(keepingCapacity: false)
         
            let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=\(self.searchingtextField.text!)&type=video&key=" + (apiKey as! String)
            
            self.mainScreenPresenterDelegate?.fetchVideos(urlString: urlString)
        }
        return true
    }
}


