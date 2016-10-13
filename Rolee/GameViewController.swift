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

	var collider: UICollisionBehavior!
	
	var animator: UIDynamicAnimator!


	@IBOutlet var gameScene: GameScene! {
		didSet {
			let recognizer = UITapGestureRecognizer(target: self, action:#selector(initScene(_:)))
			recognizer.addTarget(gameScene, action: #selector(GameScene.snapBall(_:)))
			gameScene.addGestureRecognizer(recognizer)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBarHidden = true

		self.animator = UIDynamicAnimator(referenceView: gameScene)
		self.animator.delegate = self

		self.collider = UICollisionBehavior()
		self.collider.collisionDelegate = self
		self.collider.translatesReferenceBoundsIntoBoundary = true
		
		self.animator.addBehavior(collider)
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		gameScene.collider = self.collider
		gameScene.animator = self.animator
		gameScene.animating = true
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		gameScene.animating = false
	}
	
	func initScene(recognizer: UITapGestureRecognizer) {
		if recognizer.state == .Ended {
			gameScene.createBall()
			gameScene.createExit()
			for _ in 1...level {
				gameScene.createObstacle()
			}
		}
		print(self.animator.behaviors)
	}
	
}

extension GameViewController : UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
	
	func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
		print("pause")
	}
	
	func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
		print("resume")
	}
	
	func collisionBehavior(_: UICollisionBehavior, beganContactFor: UIDynamicItem, with: UIDynamicItem, at: CGPoint) {
		print("lol")
	}
	
	func collisionBehavior(behavior: UICollisionBehavior,
	                       beganContactForItem item: UIDynamicItem,
	                                           withBoundaryIdentifier identifier: NSCopying?,
	                                                                  atPoint p: CGPoint) {
		print(p)
		// look for the dynamic item behavior
		let b = self.animator.behaviors
		if let ix = b.indexOf({$0 is UIDynamicItemBehavior}) {
			let bounce = b[ix] as! UIDynamicItemBehavior
			let v = bounce.angularVelocityForItem(item)
			print(v)
			if v <= 6 {
				print("adding angular velocity")
				bounce.addAngularVelocity(6, forItem:item)
			}
		}
	}
	
}
