//
//  BallBehavior.swift
//  Rolee
//
//  Created by simon vadée on 07/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CoreMotion

class BallBehavior: UIDynamicBehavior {

	private var motionManager = CMMotionManager()
	private var motionQueue = OperationQueue()
	
	private var ball: UIView!
	private var snap: UISnapBehavior! {
		didSet {
			snap.damping = 1
			addChildBehavior(snap)
		}
	}
		
	private let customBehavior: UIDynamicItemBehavior = {
		let behavior = UIDynamicItemBehavior()
		behavior.allowsRotation = false
		return behavior
	}()
	
	override init() {
		super.init()
		motionManager.accelerometerUpdateInterval = 0.03
		addChildBehavior(customBehavior)
	}
	
	func addItem(_ item: UIDynamicItem) {
		ball = item as? UIView
		customBehavior.addItem(ball!)
		
		// TO REMOVE !!
		snap = UISnapBehavior(item: ball!, snapTo: CGPoint.zero)

		//Start Recording Data
		
		motionManager.startAccelerometerUpdates(to: motionQueue) { [unowned self] accelerometerData, error in
			if(error != nil) {
				print("\(error)")
			}
			self.movePlayer(acceleration: accelerometerData!.acceleration)
		}
	}

	func movePlayer(acceleration: CMAcceleration){
		let horizontalSpeed = CGFloat(acceleration.x)
		let verticalSpeed = CGFloat(acceleration.y)
		
		if (horizontalSpeed > 0.1 || horizontalSpeed < -0.1) {
			ball.center.x += (horizontalSpeed * 10)
		}
		
		if (verticalSpeed > 0.1 || verticalSpeed < -0.1) {
			ball.center.y -= (verticalSpeed * 10)
		}
		
		OperationQueue.main.addOperation {
			// IF THE BALL DOES NOT MOVE, TRY TO PUT THE BELOW CODE HERE
		}
	}

	func removeItem(_ item: UIDynamicItem) {
		motionManager.stopAccelerometerUpdates()

		customBehavior.removeItem(ball!)
		if (snap != nil) {
			removeChildBehavior(snap!)
		}
	}
	
	func snapBall(_ dest: CGPoint) {
		if (snap != nil) {
			removeChildBehavior(snap!)
		}
		snap = UISnapBehavior(item: ball!, snapTo: dest)
	}
	
}

