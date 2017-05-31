//
//  GlobalConstants.swift
//  HockeyPlayers
//
//  Created by Toheed Khan on 14/05/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//


//MARK: - Server Constants

struct ServerConstants {
    
    static let kEndPointURL = "https://jc-xerxes.gpshopper.com/"
    
    //MARK: - JSON File Names

    static let kRosterJSON = "android_eval.json"

    //MARK: - Roster JSON params
    static let kRoster = "roster"

    static let kName = "name"
    static let kImageURL = "image_url"
    static let kPosition = "position"

}

//MARK: - App Constants

struct SegueIdentifiers {
    static let kHockeyPlayerDetailViewController = "HockeyPlayerDetailViewController"
}

struct TableCellIdentifiers {
    static let kHockeyPlayerTableViewCell = "HockeyPlayerTableViewCell"
}
