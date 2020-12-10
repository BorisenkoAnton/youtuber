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
    
    private init() {}
}
