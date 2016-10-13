//
//  BallBehavior.swift
//  Rolee
//
//  Created by simon vadée on 07/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior {

	fileprivate var ball: UIView? = nil
	fileprivate var snap: UISnapBehavior? {
		didSet {
			addChildBehavior(snap!)
		}
	}
	
	var collider: UICollisionBehavior? {
		didSet {
			addChildBehavior(collider!)
		}
	}
	
	func addItem(_ item: UIView) {
		ball = item
	}
	
	func removeItem(_ item: UIDynamicItem) {
	}
	
	func snapBall(_ dest: CGPoint) {
		if (snap != nil) {
			removeChildBehavior(snap!)
		}
		snap = UISnapBehavior(item: ball!, snapTo: dest)
	}
	
}

