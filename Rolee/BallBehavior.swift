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
	
	public var delegate: GameScene!
	private var ball: UIView!
	private var snap: UISnapBehavior! {
		didSet {
			snap.damping = 1
			addChildBehavior(snap)
		}
	}
		
	private var customBehavior: UIDynamicItemBehavior = {
		let behavior = UIDynamicItemBehavior()
		behavior.density = 0.5
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
		
		//Start Recording Data
		
		motionManager.startAccelerometerUpdates(to: motionQueue) { [unowned self] accelerometerData, error in
			if(error == nil) {
				
				let currentVelocity = self.customBehavior.linearVelocity(for: self.ball as UIDynamicItem)
				let xSpeed = CGFloat(accelerometerData!.acceleration.x)
				let ySpeed = CGFloat(accelerometerData!.acceleration.y) * -1
				self.customBehavior.addLinearVelocity(CGPoint(x: xSpeed * 20, y: ySpeed * 20), for: self.ball as UIDynamicItem)
//				self.customBehavior.addLinearVelocity(CGPoint(x: xSpeed * 20, y: ySpeed * 20), for: self.ball as UIDynamicItem)
				OperationQueue.main.addOperation { self.delegate.setNeedsLayout() }
				
			}
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

