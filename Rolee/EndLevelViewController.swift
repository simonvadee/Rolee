//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class EndLevelViewController: UIViewController {
	
	var score = Double(0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if score > 0 {
			print("::::::::::::::::: score --> \(score)")
		}
		else {
			GameViewController.level = 1
		}
		print("\(navigationController?.viewControllers)")
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	@IBAction func nextLevel(_ sender: UIButton) {
		GameViewController.level += 1

		_ = navigationController?.popViewController(animated: true)
	}
	
	@IBAction func tryAgain(_ sender: UIButton) {
		_ = navigationController?.popViewController(animated: false)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

