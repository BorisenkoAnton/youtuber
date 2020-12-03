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
    
    @IBOutlet weak var searchingtextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setMainScreenPresenterDelegate(delegate: MainScreenPresenter())
        self.mainScreenPresenterDelegate?.setViewDelegate(delegate: self)
    }


}


extension MainScreenViewController: MainScreenViewControllerDelegate {
    
    func setMainScreenPresenterDelegate(delegate: MainScreenPresenterDelegate) {
        
        self.mainScreenPresenterDelegate = delegate
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
         
            let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(self.searchingtextField.text!)&type=video&key=" + (apiKey as! String)
            
            self.mainScreenPresenterDelegate?.fetchVideos(urlString: urlString)
        }
        return true
    }
}


