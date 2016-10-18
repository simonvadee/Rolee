//
//  GameScene.swift
//  Rolee
//
//  Created by simon vadée on 06/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//


import UIKit

class GameScene: UIView {
	
	private var itemTag = 1
	private let ballBehavior = BallBehavior()
	private let obstaclesBehavior = ObstacleBehavior()
	private let exitBehavior = ExitBehavior()

	lazy var collider: UICollisionBehavior? = nil
	lazy var animator: UIDynamicAnimator? = nil
	
	var animating: Bool = false {
		didSet {
			if animating {
				animator!.addBehavior(ballBehavior)
				animator!.addBehavior(obstaclesBehavior)
				animator!.addBehavior(exitBehavior)
				animator!.addBehavior(collider!)
			}
			else { 
				animator!.removeBehavior(ballBehavior)
				animator!.removeBehavior(obstaclesBehavior)
				animator!.removeBehavior(exitBehavior)
				animator!.removeBehavior(collider!)
			}
		}
	}
	
	fileprivate var exitSize = CGSize(width: 100, height: 100)
	fileprivate var ballRadius = CGFloat(30)
    fileprivate var ballSize = CGSize(width: 30, height: 30)

	fileprivate var obstacleSize: CGSize {
		let x = CGFloat.random(50, max: 70)
		let y = CGFloat.random(50, max: 70)
		return CGSize(width: x, height: y)
	}
	
	fileprivate var obstacleOrigin : CGPoint {
		return CGPoint(x: CGFloat.random(50, max: bounds.size.width - exitSize.width), y: CGFloat.random(50, max: bounds.size.height - exitSize.height))
	}
	
	func createObstacle() {
		let frame = CGRect(origin: obstacleOrigin, size: obstacleSize)
		let obstacle = UIView(frame: frame)
		obstacle.tag = itemTag
		itemTag += 1
		obstacle.backgroundColor = UIColor.random
		
		addSubview(obstacle)
		collider!.addItem(obstacle)
		obstaclesBehavior.addItem(obstacle)
	}
	
	func createBall() {
		let frame = CGRect(origin: CGPoint.zero, size: ballSize)

		let ball = UIView(frame: frame)
		ball.tag = 0
		ball.backgroundColor = UIColor.red
		
		addSubview(ball)
		collider!.addItem(ball)
		ballBehavior.addItem(ball)
	}
    
    

	func createExit() {
		var frame = CGRect(origin: bounds.lowerRight, size: exitSize)
		
		frame.origin.x -= exitSize.width
		frame.origin.y -= exitSize.height
		let exit = UIView(frame: frame)
		exit.tag = -1
		exit.backgroundColor = UIColor.black
		
		addSubview(exit)
		collider!.addItem(exit)
		exitBehavior.addItem(exit)
	}
	
	func snapBall(_ recognizer: UITapGestureRecognizer) {
		ballBehavior.snapBall(recognizer.location(in: self))
	}
	
}
