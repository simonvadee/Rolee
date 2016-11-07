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
	lazy var ballBehavior: BallBehavior = {
		let behavior = BallBehavior()
		behavior.delegate = self
		return behavior
	}()
	private let obstaclesBehavior = ObstacleBehavior()
	private let exitBehavior = ExitBehavior()
    private let bulletCasterBehavior = BulletCasterBehavior()
    private let bulletBehavior = BulletBehavior()
    var timer = Timer()

	var delegate: GameSceneDelegate?
	lazy var animator: UIDynamicAnimator? = nil
	
	var animating: Bool = false {
		didSet {
			if animating {
                bulletCasterBehavior.ballDelegate = ballBehavior
                bulletBehavior.ballDelegate = ballBehavior
				delegate?.addBehaviorToAnimator(ballBehavior)
				delegate?.addBehaviorToAnimator(obstaclesBehavior)
				delegate?.addBehaviorToAnimator(exitBehavior)
                delegate?.addBehaviorToAnimator(bulletCasterBehavior)
                delegate?.addBehaviorToAnimator(bulletBehavior)
			}
			else {
				delegate?.removeBehaviorFromAnimator(ballBehavior)
				delegate?.removeBehaviorFromAnimator(obstaclesBehavior)
				delegate?.removeBehaviorFromAnimator(exitBehavior)
                delegate?.removeBehaviorFromAnimator(bulletCasterBehavior)
                delegate?.removeBehaviorFromAnimator(bulletBehavior)
			}
		}
	}
	
	fileprivate var exitSize = CGSize(width: 80, height: 80)
    fileprivate var ballSize = CGSize(width: 30, height: 30)
    fileprivate var obstacleSize = CGSize(width: 30, height: 30)
    fileprivate var obstacle2Size = CGSize(width: 60, height: 60)
    fileprivate var bulletCasterSize = CGSize(width: 32, height: 32)
    fileprivate var bulletSize = CGSize(width: 32, height: 32)
	fileprivate var ballRadius = CGFloat(30)

	fileprivate var obstacleOrigin : CGPoint {
		return CGPoint(x: CGFloat.random(50, max: bounds.size.width - exitSize.width), y: CGFloat.random(50, max: bounds.size.height - exitSize.height))
	}

	func initScene() {
		createBall()
		createExit()
        createBulletCaster()
		for i in 1...GameViewController.currentLevel {
            if(i % 2 == 0)
            {
                createObstacle2()
            }
            else
            {
                createObstacle()
            }
		}
	}
	
	func emptyScene() {
		obstaclesBehavior.removeItems()
		ballBehavior.removeItem(ball)
		exitBehavior.removeItem(exit)
        bulletCasterBehavior.removeItems()
        bulletBehavior.removeItems()
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
        let obstacle2 = UIView(frame: frame)
        obstacle2.tag = itemTag
        itemTag += 1
        
        obstacle2.backgroundColor = UIColor(patternImage: UIImage(named: "obstacle-2.png")!)
        
        addSubview(obstacle2)
        delegate?.addItemToCollider(obstacle2)
        obstaclesBehavior.addholeItem(obstacle2)
    }
	
    func createBulletCaster() {
        let frame = CGRect(origin: CGPoint(x: 330, y: 20), size: bulletCasterSize)
        let bulletCaster = UIView(frame: frame)
        bulletCaster.tag = itemTag
        itemTag += 1
        
        bulletCaster.backgroundColor = UIColor(patternImage: UIImage(named: "bullet-caster.png")!)
        
        addSubview(bulletCaster)
        delegate?.addItemToCollider(bulletCaster)
        bulletCasterBehavior.addBulletCaster(bulletCaster)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createBullet), userInfo: bulletBehavior, repeats: true)
    }
    
    func createBullet() {
        let frame = CGRect(origin: CGPoint(x: 325, y: 35), size: bulletSize)
        let bullet = UIView(frame: frame)
        bullet.tag = itemTag
        itemTag += 1
        
        bullet.backgroundColor = UIColor(patternImage: UIImage(named: "bullet.png")!)
        
        addSubview(bullet)
        delegate?.addItemToCollider(bullet)
        bulletBehavior.addBullet(bullet)
    }
    
    func createBall() {
		let frame = CGRect(origin: CGPoint.zero, size: ballSize)

		self.ball = UIView(frame: frame)
		ball.tag = 0
		ball.backgroundColor = UIColor(patternImage: UIImage(named: "small_ball.png")!)
		
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
