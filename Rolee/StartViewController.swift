//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import AudioToolbox
import CloudKit

let container = CKContainer.default()
var publicDB: CKDatabase!
var privateDB: CKDatabase!
var username: CKRecordValue!
var currentHighscore: CKRecordValue!
var currentRank: Int!

class StartViewController: UIViewController {
	
	@IBOutlet weak var loadingLabel: UILabel!
	@IBOutlet weak var tapToStartRecognizer: UITapGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)

		container.accountStatus() { [unowned self] status, error in
			switch (status) {
			case .available:
				privateDB = container.privateCloudDatabase
				publicDB = container.publicCloudDatabase
				self.initUserInfoFromCloud()
			case .couldNotDetermine: print("couldNotDetermine") //error
			case .restricted: print("restricted") //error
			case .noAccount: print("noAccount") //error
			}
		}

	}
	
	private func initUserInfoFromCloud() {
	
		container.fetchUserRecordID() { [unowned self] recordId, error in
			if error == nil {
				self.fetchUsername(recordId!)
				self.fetchHighscoreAndRank(recordId!)
			}
		}
	}
	
	private func fetchUsername(_ recordId: CKRecordID) {
		publicDB.fetch(withRecordID: recordId) { record, error in
			if record != nil {
				var _username = record!["name"]!
				if _username as! String == "" {
					_username = "bettrave" as CKRecordValue
					record!.setObject(_username as CKRecordValue?, forKey: "name")
					publicDB.save(record!) { record, error in
						username = _username
					}
				}
				else {
					username = _username
				}
			}
		}
	}
	
	private func fetchHighscoreAndRank(_ recordId: CKRecordID) {
		
		let predicate = NSPredicate(value: true)
		
		let query = CKQuery(recordType: "Highscore", predicate: predicate)
		query.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]

		let queryOperation = CKQueryOperation(query: query)
		queryOperation.resultsLimit = 1
		queryOperation.desiredKeys = ["score"]
		queryOperation.recordFetchedBlock = { [unowned self] record in
			currentHighscore = record["score"]
			print(record)
			DispatchQueue.main.async {
				self.loadingLabel.text = "Touch to start !"
				self.tapToStartRecognizer.isEnabled = true
			}
		}
		
		privateDB.add(queryOperation)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		//SystemSoundID.playFileNamed("0957")
	}
}

