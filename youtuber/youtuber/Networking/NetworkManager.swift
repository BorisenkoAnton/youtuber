//
//  NetworkManager.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation
import GoogleSignIn

class NetworkManager {
    
    static func getData(url: URL, completion: @escaping (Data, URLResponse?, Error?) -> ()) {
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            DispatchQueue.main.async(execute: {
                completion(data, response, error)
            })
        }.resume()
    }
    
    
    static func postData(url: URL, completion: @escaping (Data, URLResponse?, Error?) -> ()) {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            request.setValue("Bearer \(GIDSignIn.sharedInstance().currentUser.authentication.accessToken!)", forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }

            DispatchQueue.main.async(execute: {
                completion(data, response, error)
            })
        }.resume()
    }
}
