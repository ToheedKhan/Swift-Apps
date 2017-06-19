//
//  LocationInfo.swift
//  Locations
//
//  Created by Toheed Khan on 08/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import Foundation

//MARK: - Server Constants

struct ServerConstants {
    
    //MARK: - Locations api JSON params
    
    static let kBMWLocationID          = "ID"
    static let kNakBMWLocationName     = "Name"
    static let kBMWLocationLatitude    = "Latitude"
    static let kBMWLocationLongitude   = "Longitude"
    static let kBMWLocationAddress     = "Address"
    static let kBMWLocationArrivalTime = "ArrivalTime"
}

class Location {
    var locationId:  UInt
    var name:        String
    var latitude:    Double
    var longitude:   Double
    var address:     String
    var arrivalTime: Date


    init(locationId: UInt, name: String, latitude: Double, longitude: Double, address: String, arrivalTime: Date) {
        
        self.locationId  = locationId
        self.name        = name
        self.latitude    = latitude
        self.longitude   = longitude
        self.address     = address
        self.arrivalTime = arrivalTime
    }
    
    init?(with dictionay:Dictionary<String, AnyObject>) {
        guard let locationId = (dictionay[ServerConstants.kBMWLocationID] as? NSNumber)?.uintValue else { return nil }
        guard let name = (dictionay[ServerConstants.kNakBMWLocationName] as? String) else { return nil }
        guard let latitude = (dictionay[ServerConstants.kBMWLocationLatitude] as? Double) else { return nil }
        guard let longitude = (dictionay[ServerConstants.kBMWLocationLongitude] as? Double) else { return nil }
        guard let address = (dictionay[ServerConstants.kBMWLocationAddress] as? String) else { return nil }
        
        guard let arrivalTimeStr = (dictionay[ServerConstants.kBMWLocationArrivalTime] as? String) else { return nil }

        self.locationId = locationId
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        
        
        arrivalTime = Date.dateFromISODateTime(arrivalTimeStr)
    }
    
}

