//
//  GameScene.swift
//  Rolee
//
//  Created by simon vadée on 06/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import CoreMotion
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
 
	let manager = CMMotionManager()
	var player = SKSpriteNode()
	var endNode = SKSpriteNode()
 
	override func didMoveToView(view: SKView) {

		backgroundColor = SKColor.redColor()

		self.physicsWorld.contactDelegate = self
		player.name = "player"
		addChild(player)
		player = self.childNodeWithName("player") as! SKSpriteNode
		
		manager.startAccelerometerUpdates()
		manager.accelerometerUpdateInterval = 0.1
		manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){
			(data, error) in
			
			self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.x)!) * 10, CGFloat((data?.acceleration.y)!) * 10)
			
		}
	}
}