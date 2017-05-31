//
//  HockeyPlayerTableViewCell.swift
//  HockeyPlayers
//
//  Created by Toheed Khan on 13/05/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import UIKit

class HockeyPlayerTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
