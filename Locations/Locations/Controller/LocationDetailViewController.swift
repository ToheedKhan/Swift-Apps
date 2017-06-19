//
//  LocationDetailViewController.swift
//  Locations
//
//  Created by Toheed Khan on 07/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!

    // MARK: - Properties

    var selectedLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.selectedLocation.name
        if let arrivalTime = Date.timeDifference(from: Date(), to: selectedLocation.arrivalTime) {
            self.arrivalTimeLabel.text = arrivalTime
        }
        
        self.locationNameLabel.text = selectedLocation.name
        self.locationAddressLabel.text = selectedLocation.address
        self.latitudeLabel.text = self.latitudeLabel.text! + "\(String(describing: selectedLocation.latitude))"

        self.longitudeLabel.text = self.longitudeLabel.text! + "\(String(describing: selectedLocation.longitude))"
        
        self.navigationController?.navigationBar.accessibilityIdentifier = "LocationDetail"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let status: CLAuthorizationStatus  = CLLocationManager.authorizationStatus()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true;
        }
        
        let coord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.selectedLocation.latitude, self.selectedLocation.longitude)
        let region: MKCoordinateRegion  = MKCoordinateRegionMakeWithDistance(coord, 800, 800);
        
        self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
        
        // Add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = self.selectedLocation.address
//        annotation.subtitle = ""
        mapView.addAnnotation(annotation)

    }
}
