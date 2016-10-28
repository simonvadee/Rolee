//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit

struct Score {
	let score: Double
	let username: String
	let level: Int
}

class LeaderboardViewController: UITableViewController {
	
	private var resultsNumber = 20
	private var bestScores: [Score] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	// REQUEST WITH FILTER
	// 		let filter = username
	//		let query = CKQuery(recordType: "Highscore", predicate: NSPredicate(format: "username == %@", filter as! CVarArg))

	
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.estimatedRowHeight = tableView.rowHeight
		tableView.rowHeight = UITableViewAutomaticDimension

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-red.png")!)
		
		let query = CKQuery(recordType: "Highscore", predicate: NSPredicate(value: true))
		query.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]

		let queryOperation = CKQueryOperation(query: query)
		queryOperation.resultsLimit = resultsNumber
		queryOperation.desiredKeys = ["score", "username", "level"]
		
		queryOperation.recordFetchedBlock = { [unowned self] record in
			DispatchQueue.main.async {
				self.bestScores.append(Score(score: record["score"] as! Double,
				                             username: record["username"] as! String,
				                             level: record["level"] as! Int))
			}
			self.refreshControl?.endRefreshing()
		}
		
		publicDB.add(queryOperation)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "HighscoreTableViewCell", for: indexPath)
		if bestScores.count > indexPath.row {
			let score = bestScores[indexPath.row]
			if let scoreCell = cell as? HighscoreTableViewCell {
				scoreCell.score = score
			}
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bestScores.count
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

