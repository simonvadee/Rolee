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
var currentHighscore: Double = 0
var currentRank: Int!
var userPrivateRecord: CKRecord!
var userHasICloud = true

class StartViewController: UIViewController {
	
	@IBOutlet weak var loadingLabel: UILabel!
	@IBOutlet weak var tapToStartRecognizer: UITapGestureRecognizer!
	private var error: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)

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
				currentHighscore = 0
				username = "Anonymous" as CKRecordValue
				self.performSegue(withIdentifier: "errorSegue", sender: self)
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
				userPrivateRecord = record!
				let _username = record!["name"]
				if _username == nil || _username as! String == "" {
					self.askUserForName(record!)
				}
				else {
					username = _username
				}
			}
		}
	}
	
	private func askUserForName(_ userRecord: CKRecord) {
		let alertController = UIAlertController(title: "Greetings stranger !", message: "Please input your username:", preferredStyle: .alert)
		
		let confirmAction = UIAlertAction(title: "Yep that's me", style: .default) { [unowned self] action in
			let field = alertController.textFields![0] as UITextField
			if field.text != "" {
				DispatchQueue.main.async {
					alertController.message = "Checking if name already exists..."
				}
				self.checkIfUsernameExists(field.text!) { usernameExists in
					if usernameExists {
						DispatchQueue.main.async {
							alertController.title = "Sorry"
							alertController.message = "This name is already taken..."
							self.present(alertController, animated: true, completion: nil)
						}
					}
					else {
						let usernameRecord = CKRecord(recordType: "Username")
						usernameRecord.setObject(field.text! as CKRecordValue?, forKey: "name")
						userRecord.setObject(field.text! as CKRecordValue?, forKey: "name")
						publicDB.save(usernameRecord) { (_, _) in }
						publicDB.save(userRecord) { record, error in
							username = field.text as! CKRecordValue
						}
					}
				}
			}
			else {
				DispatchQueue.main.async {
					alertController.title = "Nice try."
					alertController.message = "Don't get too smart with me"
					self.present(alertController, animated: true, completion: nil)
				}
			}
		}
		alertController.addTextField { (textField) in
			textField.placeholder = "Name"
		}
		alertController.addAction(confirmAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	private func checkIfUsernameExists(_ name: String, _ completionHandler: @escaping (Bool) -> Void) {
		let query = CKQuery(recordType: "Username", predicate: NSPredicate(value: true))
		publicDB.perform(query, inZoneWith: nil) { records, error in
			if error == nil && records != nil {
				for record in records! {
					if record.object(forKey: "name") as? String == name {
						completionHandler(true)
						return
					}
				}
				completionHandler(false)
			}
		}
	}
	
	private func fetchHighscoreAndRank(_ recordId: CKRecordID) {
		
		let query = CKQuery(recordType: "Highscore", predicate: NSPredicate(value: true))
		query.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]

		let queryOperation = CKQueryOperation(query: query)
		queryOperation.resultsLimit = 1
		queryOperation.desiredKeys = ["score"]
		queryOperation.recordFetchedBlock = { record in
			currentHighscore = record["score"] as! Double
		}
		queryOperation.queryCompletionBlock = { [unowned self] cursor, error in
			DispatchQueue.main.async {
			self.loadingLabel.text = "Touch to start !"
			self.tapToStartRecognizer.isEnabled = true
			}
		}
		
		privateDB.add(queryOperation)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if segue.identifier == "errorSegue" {
			let errorController = segue.destination as! ErrorViewController
			self.loadingLabel.text = "Touch to start !"
			self.tapToStartRecognizer.isEnabled = true
			errorController.error = error
		}
	}
}

