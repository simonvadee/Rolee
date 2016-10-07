//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
	
	private var level = 5
	
	@IBOutlet weak var gameScene: GameScene! {
		didSet {
			gameScene.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(initScene(_:))))
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBarHidden = true
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		gameScene.animating = true
	}
	
	func initScene(recognizer: UITapGestureRecognizer) {
		if recognizer.state == .Ended {
			gameScene.createBall()
			gameScene.createExit()
			for _ in 1...level {
				gameScene.createObstacle()
			}
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		gameScene.animating = false
	}
}

