//
//  BallBehavior.swift
//  Rolee
//
//  Created by simon vadée on 07/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior {

	private var ball: UIView? = nil
	private var snap: UISnapBehavior? {
		didSet {
			addChildBehavior(snap!)
		}
	}
	
	var collider: UICollisionBehavior? {
		didSet {
			addChildBehavior(collider!)
		}
	}
	
	func addItem(item: UIView) {
		ball = item
	}
	
	func removeItem(item: UIDynamicItem) {
	}
	
	func snapBall(dest: CGPoint) {
		if (snap != nil) {
			removeChildBehavior(snap!)
		}
		snap = UISnapBehavior(item: ball!, snapToPoint: dest)
	}
	
}

