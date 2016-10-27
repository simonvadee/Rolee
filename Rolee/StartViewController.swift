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
var currentHighscore: CKRecordValue! = 0 as CKRecordValue
var currentRank: Int!
var userHasICloud = true

class StartViewController: UIViewController {
	
	@IBOutlet weak var loadingLabel: UILabel!
	@IBOutlet weak var tapToStartRecognizer: UITapGestureRecognizer!
	private var error: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
        print("Basic 1")

		container.accountStatus() { [unowned self] status, error in
			switch (status) {
			case .available:
				privateDB = container.privateCloudDatabase
				publicDB = container.publicCloudDatabase
				self.initUserInfoFromCloud()
			case .noAccount, .restricted, .couldNotDetermine:
				self.error = "set up an iCloud account for optimal experience !!"
				userHasICloud = false
				currentRank = 0
				currentHighscore = 0 as CKRecordValue
				username = "Anonymous" as CKRecordValue
				self.performSegue(withIdentifier: "errorSegue", sender: self)
			}
		}

	}
	
	private func initUserInfoFromCloud() {
	print("Cloud 1")
		container.fetchUserRecordID() { [unowned self] recordId, error in
			if error == nil {
				self.fetchUsername(recordId!)
				self.fetchHighscoreAndRank(recordId!)
			}
		}
	}
	
	private func fetchUsername(_ recordId: CKRecordID) {
        print("Username 1")
		publicDB.fetch(withRecordID: recordId) { record, error in
			if record != nil {
                print("Username 2")
				var _username = record!["name"]
				if _username == nil || _username as! String == "" {
                    print("Username 3")
					_username = "bettrave" as CKRecordValue
					record!.setObject(_username as CKRecordValue?, forKey: "name")
					publicDB.save(record!) { record, error in
						username = _username
					}
				}
				else {
					username = _username
                    print(username)
				}
			}
		}
	}
	
	private func fetchHighscoreAndRank(_ recordId: CKRecordID) {
        print("Highscore 1")
		
		let query = CKQuery(recordType: "Highscore", predicate: NSPredicate(value: true))
		query.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]

        print("Highscore 2")
		let queryOperation = CKQueryOperation(query: query)
        print("Highscore 3")
		queryOperation.resultsLimit = 1
        print("Highscore 4")
		queryOperation.desiredKeys = ["score"]
		queryOperation.recordFetchedBlock = { record in
			currentHighscore = record["score"]
            print("Highscore 7")
		}
		queryOperation.queryCompletionBlock = { [unowned self] cursor, error in
			DispatchQueue.main.async {
			print("Highscore 8")
			self.loadingLabel.text = "Touch to start !"
			self.tapToStartRecognizer.isEnabled = true
			}
		}
		
		privateDB.add(queryOperation)
        print("Highscore 9")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare 1")
		super.prepare(for: segue, sender: sender)
		if segue.identifier == "errorSegue" {
			let errorController = segue.destination as! ErrorViewController
			self.loadingLabel.text = "Touch to start !"
			self.tapToStartRecognizer.isEnabled = true
			print("Prepare 2")
			errorController.error = error
		}
		//SystemSoundID.playFileNamed("0957")
	}
}

