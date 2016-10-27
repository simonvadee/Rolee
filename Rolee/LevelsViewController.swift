//
//  LevelsViewController.swift
//  Rolee
//
//  Created by Iris Poot on 24-10-16.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit

class LevelsViewController: UITableViewController {
	
	private var maxLevel = 1  {
		didSet {
			tableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
		
		tableView.estimatedRowHeight = tableView.rowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
		
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-red.png")!)
		if userHasICloud {
			loadLevelsFromCloud()
		}
	}
	
	func loadLevelsFromCloud() {
		let query = CKQuery(recordType: "Highscore", predicate: NSPredicate(value: true))
		query.sortDescriptors = [NSSortDescriptor(key: "level", ascending: false)]
		
		let queryOperation = CKQueryOperation(query: query)
		queryOperation.resultsLimit = 1
		queryOperation.desiredKeys = ["level"]
		
		queryOperation.recordFetchedBlock = { [unowned self] record in
			DispatchQueue.main.async {
				self.maxLevel = record["level"] as! Int
			}
			self.refreshControl?.endRefreshing()
		}
		
		privateDB.add(queryOperation)

	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCell", for: indexPath)
		let level = indexPath.row + 1
		if let levelCell = cell as? LevelTableViewCell {
			levelCell.levelLabel.text = String(level)
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return maxLevel
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
	}
}


