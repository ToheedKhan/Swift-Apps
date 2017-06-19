//
//  LocationTracker.swift
//  Locations
//
//  Created by Toheed Khan on 11/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager
    var currentLocation: CLLocation
    
    
    //MARK: Shared instance
    
    static let sharedInstance : LocationTracker = {
        
        // CLLocationManager must be created on main thread otherwise
        // it will generate an error at init time.
        if Thread.isMainThread {
            return LocationTracker()
        } else {
            return DispatchQueue.main.sync {
                   return LocationTracker()
            }
        }
        
    }()
    
    // MARK: Initialization
    
    override init() {
        
        self.locationManager = CLLocationManager()
        self.currentLocation = CLLocation(latitude:0.0, longitude:0.0)
        
        super.init()

        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 100 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
    }

    
    // MARK:
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager.stopUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        print("Location service failed with error \(error)");
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("Starting location updates...")
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse :
            manager.startUpdatingLocation()
        case .notDetermined :
            manager.requestWhenInUseAuthorization()
        case .restricted,.denied :
            
            let alertController = UIAlertController(
                title: "Location services not authorized",
                message: "This app needs you to authorize locations services to work.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        }
    }

}


