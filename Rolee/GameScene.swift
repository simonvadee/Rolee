//
//  GameScene.swift
//  Rolee
//
//  Created by simon vadée on 06/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import CoreMotion
import UIKit

class GameScene: UIView, UIDynamicAnimatorDelegate {
 
	let manager = CMMotionManager()
	
	private lazy var animator : UIDynamicAnimator = {
		let animator = UIDynamicAnimator(referenceView: self)
		animator.delegate = self
		return animator
	}()
	
	private var ballBehavior = BallBehavior()
	private var obstaclesBehavior = ObstacleBehavior()
	private var exitBehavior = ExitBehavior()
	
	var animating: Bool = false {
		didSet {
			if animating {
				animator.addBehavior(ballBehavior)
			}
			else { 
				animator.removeBehavior(ballBehavior)
			}
		}
	}
	
	private var exitSize = CGSize(width: 100, height: 100)
	private var ballRadius = CGFloat(50)
	
	private var obstacleSize: CGSize {
		let x = CGFloat.random(0, max: 100)
		let y = CGFloat.random(0, max: 100)
		return CGSize(width: x, height: y)
	}
	
	private var obstacleOrigin : CGPoint {
		return CGPoint(x: CGFloat.random(50, max: Int(bounds.size.width)), y: CGFloat.random(50, max: Int(bounds.size.height)))
	}
	
	func createObstacle() {
		let frame = CGRect(origin: obstacleOrigin, size: obstacleSize)

		let obstacle = UIView(frame: frame)
		obstacle.backgroundColor = UIColor.random
		
		addSubview(obstacle)
		obstaclesBehavior.addItem(obstacle)
	}
	
	func createBall() {
		let frame = CGRect(origin: CGPoint.zero, size: obstacleSize)
		
		let ball = UIView(frame: frame)
		ball.backgroundColor = UIColor.redColor()
		
		addSubview(ball)
		ballBehavior.addItem(ball)
	}

	func createExit() {
		var frame = CGRect(origin: bounds.lowerRight, size: exitSize)
		
		frame.origin.x -= exitSize.width
		frame.origin.y -= exitSize.height
		let exit = UIView(frame: frame)
		exit.backgroundColor = UIColor.blackColor()
		
		addSubview(exit)
		exitBehavior.addItem(exit)
	}

	
}