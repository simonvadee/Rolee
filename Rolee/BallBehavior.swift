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
	internal var ball: UIView!
	public var snap: UISnapBehavior! {
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
				
				self.customBehavior.addLinearVelocity(CGPoint(x: -(currentVelocity.x / 2), y: -(currentVelocity.y / 2)), for:self.ball as UIDynamicItem)
				self.customBehavior.addLinearVelocity(CGPoint(x: xSpeed * 300, y: ySpeed * 300), for: self.ball as UIDynamicItem)
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

extension BallBehavior : BallDelegate {
    internal func getBallPosition() -> CGPoint {
        return self.ball.center
    }
    
//    internal func getAngle(_ item : UIDynamicItem) -> CGFloat {
//        let v1 = CGVector(dx: self.ball.center.x - item.center.x, dy: self.ball.center.y - item.center.y)
//        let v2 = CGVector(dx: item.center.x - item.center.x, dy: item.center.y - item.center.y)
//        
//        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
//        
//        let deg = angle * CGFloat(180.0 / M_PI)
//        
//        return deg
//    }
}

protocol BallDelegate {
    func getBallPosition() -> CGPoint
//    func getAngle(_ item : UIDynamicItem) -> CGFloat
}
