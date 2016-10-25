//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit

let container = CKContainer.default()
var publicDB: CKDatabase!
var privateDB: CKDatabase!
var username: CKRecordValue!

class HomeViewController: UIViewController {


	override func viewDidLoad() {
		super.viewDidLoad()
		
		container.accountStatus() { status, error in
			switch (status) {
			case .available:
				privateDB = container.privateCloudDatabase
				publicDB = container.publicCloudDatabase
				container.fetchUserRecordID() { recordId, error in
					publicDB.fetch(withRecordID: recordId!) { record, error in
							if record != nil {
								var _username = record!["name"]!
								if _username as! String == "" {
									_username = "bettrave" as CKRecordValue
									record!.setObject(_username as CKRecordValue?, forKey: "name")
									publicDB.save(record!) { record, error in
										username = _username
										print("\(record)")}
								}
								else {
									username = _username
									print("\(username)")
								}
						}
					}
				}
			case .couldNotDetermine: print("couldNotDetermine")
			case .restricted: print("restricted")
			case .noAccount: print("noAccount")
			}
		}
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

