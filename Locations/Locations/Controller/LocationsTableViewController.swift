//
//  LocationsTableViewController.swift
//  Locations
//
//  Created by Toheed Khan on 07/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import UIKit
import CoreLocation

enum SortingOptions: Int {
    case name        = 0
    case arrivalTime = 1
    case distance    = 2
}

class LocationsTableViewController: UITableViewController {

    // MARK: - Properties

    var locations: Array = [Location]()
    var sortOption: SortingOptions = SortingOptions.distance
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    
    private let locationsRefreshControl = UIRefreshControl()
    private let refreshControlTintColor = UIColor.init(colorLiteralRed: 0.93, green: 0.64, blue: 0.165, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.setupUI()
        
        //Fetch location data
        self.fetchLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Deinitialization
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(LocationTracker.sharedInstance.currentLocation))
    }

    
    // MARK: - Key-Value Observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(LocationTracker.sharedInstance.currentLocation) {
            if (self.sortOption == .distance) {
                sortLocations()
            }
        }
    }

      // MARK: - Actions
    
    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Sort by", message: "Select an option to sort location", preferredStyle: .actionSheet)
        alertController.view.layer.borderColor = UIColor.black.cgColor
        alertController.view.layer.borderWidth = 1.0
        alertController.view.layer.cornerRadius = 8.0
        
        let sortByNameButton = UIAlertAction(title: "Sort by name", style: .default, handler: { (action) -> Void in
            self.sortOption = .name
            self.sortLocations()
        })
        
        let  sortByDistanceButton = UIAlertAction(title: "Sort by distance", style: .default, handler: { (action) -> Void in
            self.sortOption = .distance
            self.sortLocations()
        })
        
        let sortByArrivalTimeButton = UIAlertAction(title: "Sort by arrival time", style: .default, handler: { (action) -> Void in
            self.sortOption = .arrivalTime
            self.sortLocations()
        })
        
        
        alertController.addAction(sortByNameButton)
        alertController.addAction(sortByDistanceButton)
        alertController.addAction(sortByArrivalTimeButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func refreshLocationData(sender: UIRefreshControl) {
        fetchLocations()
    }
    
    // MARK: - UI methods
    
    func setupUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.init(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        
        self.tableView.accessibilityIdentifier = "LocationsTable"
        
        self.view.addSubview(loadingIndicator)
        self.loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        showIndicator()
        
        setupTableView()
        
    }
    
    private func setupTableView() {
        
        // Helpers
        let attributes = [ NSForegroundColorAttributeName : refreshControlTintColor ] as [String: Any]
        
        // Configure Refresh Control
        locationsRefreshControl.tintColor = refreshControlTintColor
        locationsRefreshControl.attributedTitle = NSAttributedString(string: "Fetching Location Data ...", attributes: attributes)
        locationsRefreshControl.addTarget(self, action: #selector(LocationsTableViewController.refreshLocationData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = locationsRefreshControl
        } else {
            tableView.addSubview(locationsRefreshControl)
        }
    }

    
    func showIndicator() {
       
        self.loadingIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func hideIndicator() {
        self.loadingIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: Helper functions
    
    
    func fetchLocations() {
        LocationFetcher.sharedInstance.fetchLocations { [unowned self]  (locations, error) in
            if let fetchedLocations = locations {
                print(fetchedLocations)
                
                if fetchedLocations.count > 0 {
                    self.locations = fetchedLocations as! [Location]
                    
                    DispatchQueue.main.async {
                        self.sortLocations()
                        self.locationsRefreshControl.endRefreshing()
                        self.hideIndicator()
                    }
                }
            }
            else {
                print(error)
                //Handle error here. We can show alert or retry fetching here
            }
        }
    }

    func setupLocationUpdates() -> Void {
        addObserver(self, forKeyPath: #keyPath(LocationTracker.sharedInstance.currentLocation), options: [.new], context: nil)
        LocationTracker.sharedInstance.startUpdatingLocation()
    }
    
    
    func sortLocations() -> Void {
      
        switch sortOption {
        case SortingOptions.name:
         locations.sort(by: { (location1: Location, location2: Location) -> Bool in
                return location1.name < location2.name
            })
            
        case SortingOptions.arrivalTime:
            locations.sort(by: {( $0.arrivalTime < $1.arrivalTime)})
            
        case SortingOptions.distance:
            let currentLocation = LocationTracker.sharedInstance.currentLocation
         
            let sortedlocations = locations.sorted  { (loc1, loc2) in
              
            let location1 = CLLocation(latitude:loc1.latitude, longitude:loc1.longitude)
            let location2 = CLLocation(latitude:loc2.latitude, longitude:loc2.longitude)
                let distance1:CLLocationDistance = location1.distance(from: currentLocation)
                let distance2:CLLocationDistance = location2.distance(from: currentLocation)
            
                if (distance1 < distance2) || (distance1 == distance2) {
                  return true
                }
                else {
                  return false
                }

            }
            
            locations = sortedlocations

        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.LocationCell, for: indexPath)
        
        let location = locations[indexPath.row]
        
        // Configure the cell...

        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = location.address

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let selectedRow = self.tableView.indexPathForSelectedRow?.row
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == Constants.SegueIdentifiers.LocationDetail {
            let vc = segue.destination as! LocationDetailViewController
            
            // Pass the selected object to the new view controller.
            vc.selectedLocation = self.locations[selectedRow!]
        }

    }
 

}
