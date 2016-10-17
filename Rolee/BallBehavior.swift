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
	
	func addItem(_ item: UIDynamicItem) {
		ball = item as? UIView
		snap = UISnapBehavior(item: ball!, snapTo: CGPoint(x: 0, y: 0))
	}
	
	func removeItem(_ item: UIDynamicItem) {
		ball = nil
		removeItem(item)
	}
	
	func snapBall(_ dest: CGPoint) {
		if (snap != nil) {
			removeChildBehavior(snap!)
		}
		snap = UISnapBehavior(item: ball!, snapTo: dest)
	}
	
}

