//
//  Notification.Name+signInGoogleCompleted.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/7/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
