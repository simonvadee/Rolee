//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import AudioToolbox

class StartViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("start loaded")
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        SystemSoundID.playFileNamed("0957")
		print("before segue")
	}
}

