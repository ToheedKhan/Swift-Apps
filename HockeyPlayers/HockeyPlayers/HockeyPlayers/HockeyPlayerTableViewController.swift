//
//  HockeyPlayerTableViewController.swift
//  HockeyPlayers
//
//  Created by Toheed Khan on 13/05/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import UIKit

class HockeyPlayerTableViewController: UITableViewController {

    //MARK: Properties
    var hockeyPlayersRoster = [HockeyPlayer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPlayersDataFromServer();

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hockeyPlayersRoster.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = TableCellIdentifiers.kHockeyPlayerTableViewCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HockeyPlayerTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HockeyPlayerTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let player = hockeyPlayersRoster[indexPath.row]
        
        cell.nameLabel.text = player.name
        cell.positionLabel.text = player.position
        let imageDownloader: ImageDownloader = ImageDownloader()
        
        imageDownloader.downloadImage(from: player.photoURL, indexPath: indexPath) { (image) in
            if let image = image {
                DispatchQueue.main.async(execute: { () -> Void in
                
                    // Before we assign the image, check whether the current cell is visible
                    if let updateCell = tableView.cellForRow(at: indexPath) as? HockeyPlayerTableViewCell{
                        updateCell.photoImageView.image = image;
                        updateCell.indicatorView.stopAnimating()
                        player.photo = image;
                    }
                })

            }
        }
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       let selectedRow = self.tableView.indexPathForSelectedRow?.row
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == SegueIdentifiers.kHockeyPlayerDetailViewController {
            let vc = segue.destination as! HockeyPlayerDetailViewController
            
            // Pass the selected object to the new view controller.
            vc.selectedPlayer = self.hockeyPlayersRoster[selectedRow!]
        }
    }
 

    //MARK: - Fetch Players data
    
    func fetchPlayersDataFromServer() {
        let serverEndPoint: String = "https://jc-xerxes.gpshopper.com/android_eval.json"
        
        guard let url = URL(string: serverEndPoint) else {
            print("Error: cannot create URL")
return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
return
            }
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Players roster recieved successfully.")
            }
           
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.didRecieve(hockeyPlayers: jsonResult)
            }
            catch let err {
                print(err.localizedDescription)
            }
            }.resume()
        
    }
    
    func didRecieve(hockeyPlayers: [String: Any]) -> Void {
        // Make sure the players roster data is in the expected format of [String: Any]
        guard let playersRoster = hockeyPlayers[ServerConstants.kRoster] as? [[String: Any]] else {
            print("Could not process search results...")
            return
        }
        
        // Create a temporary place to add the new list of app details to
        var players = [HockeyPlayer]()
        
        // Loop through all the results...
        for result in playersRoster {
            // Check that we have String values for each key
            if let name = result[ServerConstants.kName] as? String,
                let photoUrl = URL(string: (result[ServerConstants.kImageURL] as? String)!),
                let position = result[ServerConstants.kPosition] as? String {
                
                // All three data points are valid, add the record to the list
                
                players.append(HockeyPlayer(name:name, position:position, photoURL:photoUrl)!)
                
            }
            
        }
        
        if players.count > 0 {
            self.hockeyPlayersRoster = players
            // Refresh the table with the new data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
}
