//
//  HockeyPlayer.swift
//  HockeyPlayers
//
//  Created by Toheed Khan on 13/05/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import UIKit

class HockeyPlayer {
    //MARK: Properties
    
    var name: String
    var position: String
    var photoURL: URL

    var photo: UIImage?


    //MARK: Initialization
    
    init?(name: String, position: String, photoURL: URL, photo: UIImage? = nil) {
        
        // Initialize stored properties.
        self.name = name
        self.position = position
        self.photoURL = photoURL
        self.photo = nil

    }
    
    
}
