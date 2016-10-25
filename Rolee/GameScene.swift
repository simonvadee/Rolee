//
//  GameScene.swift
//  Rolee
//
//  Created by simon vadée on 06/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import CoreMotion
import UIKit

class GameScene: UIView {
	
    var ball: UIView!
	private var exit: UIView!
	
	private var itemTag = 1
	private let ballBehavior = BallBehavior()
	private let obstaclesBehavior = ObstacleBehavior()
	private let exitBehavior = ExitBehavior()

	var delegate: GameSceneDelegate?
	lazy var animator: UIDynamicAnimator? = nil
	
	var animating: Bool = false {
		didSet {
			if animating {
				delegate?.addBehaviorToAnimator(ballBehavior)
				delegate?.addBehaviorToAnimator(obstaclesBehavior)
				delegate?.addBehaviorToAnimator(exitBehavior)
			}
			else {
				delegate?.removeBehaviorFromAnimator(ballBehavior)
				delegate?.removeBehaviorFromAnimator(obstaclesBehavior)
				delegate?.removeBehaviorFromAnimator(exitBehavior)
			}
		}
	}
	
	fileprivate var exitSize = CGSize(width: 80, height: 80)
    fileprivate var ballSize = CGSize(width: 60, height: 60)
    fileprivate var obstacleSize = CGSize(width: 70, height: 70)
    fileprivate var obstacle2Size = CGSize(width: 90, height: 90)
	fileprivate var ballRadius = CGFloat(30)
	
	
	fileprivate var obstacleOrigin : CGPoint {
		return CGPoint(x: CGFloat.random(50, max: bounds.size.width - exitSize.width), y: CGFloat.random(50, max: bounds.size.height - exitSize.height))
	}

	func initScene() {
		createBall()
		createExit()
		for _ in 1...GameViewController.level {
			createObstacle()
            createObstacle2()
		}
	}
	
	func emptyScene() {
		obstaclesBehavior.removeItems()
		ballBehavior.removeItem(ball)
		exitBehavior.removeItem(exit)

		for view in self.subviews {
			view.removeFromSuperview()
		}
	}

	func createObstacle() {
		let frame = CGRect(origin: obstacleOrigin, size: obstacleSize)
		let obstacle = UIView(frame: frame)
		obstacle.tag = itemTag
		itemTag += 1
        
		obstacle.backgroundColor = UIColor(patternImage: UIImage(named: "obstacle-1.png")!)
		
		addSubview(obstacle)
		delegate?.addItemToCollider(obstacle)
		obstaclesBehavior.addItem(obstacle)
	}
    
    func createObstacle2() {
        let frame = CGRect(origin: obstacleOrigin, size: obstacle2Size)
        let obstacle = UIView(frame: frame)
        obstacle.tag = itemTag
        itemTag += 1
        
        obstacle.backgroundColor = UIColor(patternImage: UIImage(named: "obstacle-2.png")!)
        
        addSubview(obstacle)
        delegate?.addItemToCollider(obstacle)
    }
	
	func createBall() {
		let frame = CGRect(origin: CGPoint.zero, size: ballSize)

		self.ball = UIView(frame: frame)
		ball.tag = 0
		ball.backgroundColor = UIColor(patternImage: UIImage(named: "ball.png")!)
		
		addSubview(ball)
		delegate?.addItemToCollider(ball)
		ballBehavior.addItem(ball)
	}

	func createExit() {
		var frame = CGRect(origin: bounds.lowerRight, size: exitSize)
		
		frame.origin.x -= exitSize.width
		frame.origin.y -= exitSize.height
		self.exit = UIView(frame: frame)
		exit.tag = -1
		exit.backgroundColor = UIColor(patternImage: UIImage(named: "safe-space.png")!)
		
		addSubview(exit)
		delegate?.addItemToCollider(exit)
		exitBehavior.addItem(exit)
	}
	
	func snapBall(_ recognizer: UITapGestureRecognizer) {
		ballBehavior.snapBall(recognizer.location(in: self))
	}
	
}
