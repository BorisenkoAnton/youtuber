//
//  AlertHelper.swift
//  youtuber
//
//  Created by Anton Borisenko on 12/9/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class AlertHelper {
    
    static func createAlert(title: String, message: String, preferredStyle: UIAlertController.Style) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        return alert
    }
}
