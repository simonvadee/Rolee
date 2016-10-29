//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
	
	var audioController: AudioPlayer! = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
		// Do any additional setup after loading the view, typically from a nib.
	}

	@IBAction func switchMusic(_ sender: UISwitch) {
		if sender.isOn {
			audioController.playSound()
		}
		else {
			audioController.stopSoundAndMusic()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

