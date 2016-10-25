//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit

class LeaderboardViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-red.png")!)
		
		let predicate = NSPredicate(value: true)
		let query = CKQuery(recordType: "Highscore", predicate: predicate)
		let queryOperation = CKQueryOperation(query: query)
		queryOperation.resultsLimit = 10
		queryOperation.desiredKeys = ["score", "username", "level"]
		queryOperation.queryCompletionBlock = { cursor, error in
			print(cursor)
		}
		queryOperation.recordFetchedBlock = { record in
			print(record)
		}
		publicDB.add(queryOperation)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

