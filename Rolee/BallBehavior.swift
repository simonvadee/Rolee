//
//  BallBehavior.swift
//  Rolee
//
//  Created by simon vadée on 07/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior {

	var collider: UICollisionBehavior? {
		didSet {
			addChildBehavior(collider!)
		}
	}
	
	override init() {
		super.init()
	}
	
	func addItem(item: UIDynamicItem) {
	}
	
	func removeItem(item: UIDynamicItem) {
	}
	
}

