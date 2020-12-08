//
//  ViewController.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import GoogleSignIn

class MainScreenViewController: UIViewController {

    private var videosArray = Array<Dictionary<String, Any>>()

    var mainScreenPresenterDelegate: MainScreenPresenterDelegate?
    var selectedVideoIndex: Int?
    
    @IBOutlet weak var searchingtextField: UITextField!
    @IBOutlet weak var videosTable: UITableView!
    @IBOutlet weak var signButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureController()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "idPlayerSegue" && selectedVideoIndex != nil {
            let playerViewController = segue.destination as! PlayerViewController
            
            playerViewController.videoID = (videosArray[selectedVideoIndex!]["videoID"] as! String)
        }
    }
    
    
    private func configureController() {
        
        self.setMainScreenPresenterDelegate(delegate: MainScreenPresenter())
        self.mainScreenPresenterDelegate?.setViewDelegate(delegate: self)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/youtube"]
        
        signButton.target = self
        signButton.action = #selector(signButtonPressed(_:))
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignInGoogle(_:)), name: .signInGoogleCompleted, object: nil)
    }
    
    
    private func updateSignButtonTitle() {
    
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            signButton.title = "Sign out"
        } else {
            signButton.title = "Sign in"
        }
    }
    
    
    @objc func signButtonPressed(_ sender: UIBarButtonItem) {
        
        if self.signButton.title == "Sign in" {
            GIDSignIn.sharedInstance()?.signIn()
        } else {
            GIDSignIn.sharedInstance()?.signOut()
            updateSignButtonTitle()
        }
    }
    
    
    @objc func userDidSignInGoogle(_ notification: Notification) {
        
            updateSignButtonTitle()
    }
}


extension MainScreenViewController: MainScreenViewControllerDelegate {
    
    func setMainScreenPresenterDelegate(delegate: MainScreenPresenterDelegate) {
        
        self.mainScreenPresenterDelegate = delegate
    }
    
    
    func setVideos(videos: Array<Dictionary<String, Any>>) {
        
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
        
        cell.videoNameLabel.text = videoDetails["title"] as? String
        cell.thumbnailImageView.image = UIImage(data: NSData(contentsOf: NSURL(string: (videoDetails["thumbnail"] as? String)!)! as URL)! as Data)
        cell.publishedAtLabel.text = videoDetails["publishedAt"] as? String
        
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
         
            let urlString: String = ("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=\(self.searchingtextField.text!)&type=video&key=" + (apiKey as! String)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            self.mainScreenPresenterDelegate?.fetchVideos(urlString: urlString)
        }
        return true
    }
}


