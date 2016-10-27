//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit

class HomeViewController: UIViewController {


	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var highscoreLabel: UILabel!
	@IBOutlet weak var rankLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	 private func updateUserInfo() {
		if username != nil {
			self.usernameLabel.text = username as? String
		}
		if currentHighscore != nil {
			self.highscoreLabel.text = String(format: "%.f", currentHighscore as! Double)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
		updateUserInfo()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

