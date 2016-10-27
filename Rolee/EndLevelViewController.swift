//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit

class EndLevelViewController: UIViewController {
	
	static var score = Double(0)
	
	@IBOutlet weak var levelDisplay: UILabel!
	@IBOutlet weak var scoreDisplay: UILabel!
	
	@IBAction func postScoreToLeaderboard(_ sender: UIButton) {
		let highscoreRecord = CKRecord(recordType: "Highscore")
		
		highscoreRecord["level"] = GameViewController.level as CKRecordValue
		highscoreRecord["score"] = EndLevelViewController.score as CKRecordValue
		highscoreRecord["username"] = username as CKRecordValue

		publicDB.save(highscoreRecord) { record, error in
		}
		privateDB.save(highscoreRecord) { record, error in
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		levelDisplay.text = "Level " + String(GameViewController.level)
		scoreDisplay.text = String(format: "%.f", EndLevelViewController.score)
		
		if EndLevelViewController.score > currentHighscore as! Double {
			currentHighscore = EndLevelViewController.score as CKRecordValue
		}
	}
	
	@IBAction func nextLevel(_ sender: UIButton) {
		GameViewController.level += 1

		_ = navigationController?.popViewController(animated: true)
	}
	
	@IBAction func tryAgain(_ sender: UIButton) {
		EndLevelViewController.score = 0
		GameViewController.level = 1
		_ = navigationController?.popViewController(animated: false)
	}
	
	@IBAction func returnToHome(_ sender: UIButton) {
		GameViewController.level = 1
		EndLevelViewController.score = 0
		_ = navigationController?.popToRootViewController(animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

