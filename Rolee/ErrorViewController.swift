//
//  ErrorViewController.swift
//  Rolee
//
//  Created by simon vadée on 26/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

	@IBAction func returnToPreviousScreen(_ sender: UIButton) {
		_ = navigationController?.popViewController(animated: false)
	}
}
