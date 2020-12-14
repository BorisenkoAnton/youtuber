//
//  NetworkConfiguration.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/10/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

struct NetworkConfiguration {
    
    static var shared = NetworkConfiguration()
    
    var apiKey: String?
    var clientID: String?
    var base: String?
    
    private init() {}
    
    
    static func configure() {
        
        guard let path = Bundle.main.path(forResource: "APIConfig", ofType: "plist") else { return }
           
        let apiConfigAsDictionary = NSDictionary(contentsOfFile: path)

        let apiKey = apiConfigAsDictionary!["API key"] as! String
        let clientID = apiConfigAsDictionary!["Client ID"] as! String
        let baseAddress = apiConfigAsDictionary!["Base address"] as! String
        
        NetworkConfiguration.shared.apiKey = apiKey
        NetworkConfiguration.shared.clientID = clientID
        NetworkConfiguration.shared.base = baseAddress
    }
}
