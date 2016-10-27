//
//  HighscoreTableViewCell.swift
//  Rolee
//
//  Created by Iris Poot on 11-10-16.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class HighscoreTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
	
	var score: Score! {
		didSet {
			scoreLabel.text = String(format: "%.f", score.score)
			levelLabel.text = String(score.level)
			userLabel.text = score.username
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
