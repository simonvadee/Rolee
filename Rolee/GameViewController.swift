//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit
import CoreMotion

class GameViewController: UIViewController {
    
    let motionManager = CMMotionManager()
	
	private var level = 5
	
	private let container = CKContainer.default()
	private var publicDB: CKDatabase!
	private var privateDB: CKDatabase!

	private var collider: UICollisionBehavior!
	var animator: UIDynamicAnimator!


	@IBOutlet weak var gameScene: GameScene! {
		didSet {
			let recognizer = UITapGestureRecognizer(target: gameScene, action:#selector(GameScene.snapBall(_:)))
			gameScene.addGestureRecognizer(recognizer)

			self.animator = UIDynamicAnimator(referenceView: gameScene)
			self.animator.delegate = self
			
			self.collider = UICollisionBehavior()
			self.collider.collisionDelegate = self
			self.collider.translatesReferenceBoundsIntoBoundary = true
			
			self.animator.addBehavior(collider)

			gameScene.collider = self.collider
			gameScene.animator = self.animator
			gameScene.animating = true
			initScene()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = true
		
		container.accountStatus() { status, error in
			switch (status) {
				case .available: print("available")
				case .couldNotDetermine: print("couldNotDetermine")
				case .restricted: print("restricted")
				case .noAccount: print("noAccount")
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		gameScene.animating = false
	}
	
	func initScene() {
		gameScene.createBall()
		gameScene.createExit()
		for _ in 1...level {
			gameScene.createObstacle()
		}
	}
	
}

extension GameViewController : UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
	
	func collisionBehavior(_ behavior: UICollisionBehavior,
	                       beganContactFor item1: UIDynamicItem,
	                       with item2: UIDynamicItem,
	                       at: CGPoint) {
		let firstItem = (item1 as? UIView)!.tag
		let secondItem = (item2 as? UIView)!.tag
		
		switch (firstItem, secondItem) {
		// collision between ball and exit
			case (0, -1):
				performSegue(withIdentifier: "winSegue", sender: self)
				print("win")
				
		// collision between ball and obstacle
			case (0, _):
				performSegue(withIdentifier: "loseSegue", sender: self)
				print("lose")
		// collision between obstacles and/or exit
			default:
				break
		}
	}
}
