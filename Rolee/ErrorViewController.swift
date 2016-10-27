//
//  ErrorViewController.swift
//  Rolee
//
//  Created by simon vadée on 26/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

	@IBOutlet weak var errorLabel: UILabel!
	
	var error: String!
	
	override func viewWillAppear(_ animated: Bool) {
		errorLabel.text = error
	}
	
	@IBAction func returnToPreviousScreen(_ sender: UIButton) {
		if navigationController != nil {
			let _ = navigationController?.popViewController(animated: true)
		}
		else {
			self.dismiss(animated: true, completion: nil)
		}
	}
}
