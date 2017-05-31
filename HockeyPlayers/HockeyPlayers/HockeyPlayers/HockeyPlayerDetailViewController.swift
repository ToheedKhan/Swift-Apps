//
//  HockeyPlayerDetailViewController.swift
//  HockeyPlayers
//
//  Created by Toheed Khan on 14/05/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import UIKit

class HockeyPlayerDetailViewController: UIViewController {

    //MARK: - Properties
    var selectedPlayer: HockeyPlayer!
    
    //MARK: IBOutlets
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = selectedPlayer.name

        positionLabel.text = String(format: "Position :-              %@", selectedPlayer.position)
        
        photoImageView.image = selectedPlayer.photo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
