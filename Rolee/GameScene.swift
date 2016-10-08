//
//  GameScene.swift
//  Rolee
//
//  Created by simon vadée on 06/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import CoreMotion
import UIKit

class GameScene: UIView, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
 
	let manager = CMMotionManager()
	
	private lazy var animator : UIDynamicAnimator = {
		let animator = UIDynamicAnimator(referenceView: self)
		animator.delegate = self
		return animator
	}()

	private lazy var collider: UICollisionBehavior = {
		let collider = UICollisionBehavior()
		collider.translatesReferenceBoundsIntoBoundary = true
		collider.collisionDelegate = self
		return collider
	}()
	
	private let ballBehavior = BallBehavior()
	private let obstaclesBehavior = ObstacleBehavior()
	private let exitBehavior = BallBehavior()

	var animating: Bool = false {
		didSet {
			if animating {
				animator.addBehavior(ballBehavior)
				animator.addBehavior(obstaclesBehavior)
				animator.addBehavior(exitBehavior)
				animator.addBehavior(collider)
			}
			else { 
				animator.removeBehavior(ballBehavior)
				animator.removeBehavior(obstaclesBehavior)
				animator.removeBehavior(exitBehavior)
				animator.removeBehavior(collider)
			}
		}
	}
	
	private var exitSize = CGSize(width: 100, height: 100)
	private var ballRadius = CGFloat(50)
	
	private var obstacleSize: CGSize {
		let x = CGFloat.random(50, max: 100)
		let y = CGFloat.random(50, max: 100)
		return CGSize(width: x, height: y)
	}
	
	private var obstacleOrigin : CGPoint {
		return CGPoint(x: CGFloat.random(50, max: bounds.size.width - exitSize.width), y: CGFloat.random(50, max: bounds.size.height - exitSize.height))
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		ballBehavior.collider = collider
		obstaclesBehavior.collider = collider
		exitBehavior.collider = collider
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder:aDecoder)
	}
	
	func collisionBehavior(behavior: UICollisionBehavior,
	                       beganContactFor item1: UIDynamicItem,
							with item2: UIDynamicItem,
							     at p: CGPoint) {
		print("a")
	}
	
	func collisionBehavior(_: UICollisionBehavior, beganContactFor: UIDynamicItem, withBoundaryIdentifier: NSCopying?, at: CGPoint) {
		print("b")
	}
	
	func createObstacle() {
		let frame = CGRect(origin: obstacleOrigin, size: obstacleSize)
		let obstacle = UIView(frame: frame)
		obstacle.backgroundColor = UIColor.random
		
		addSubview(obstacle)
		collider.addItem(obstacle)
		obstaclesBehavior.addItem(obstacle)
	}
	
	func createBall() {
		let frame = CGRect(origin: CGPoint.zero, size: obstacleSize)

		let ball = UIView(frame: frame)
		ball.backgroundColor = UIColor.redColor()
		
		addSubview(ball)
		collider.addItem(ball)
		ballBehavior.addItem(ball)
	}

	func createExit() {
		var frame = CGRect(origin: bounds.lowerRight, size: exitSize)
		
		frame.origin.x -= exitSize.width
		frame.origin.y -= exitSize.height
		let exit = UIView(frame: frame)
		exit.backgroundColor = UIColor.blackColor()
		
		addSubview(exit)
		collider.addItem(exit)
		exitBehavior.addItem(exit)
	}

	
}