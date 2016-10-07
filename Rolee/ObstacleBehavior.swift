//
//  ObstacleBehavior.swift
//  Rolee
//
//  Created by simon vadée on 07/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class ObstacleBehavior: UIDynamicBehavior {

	private let collider: UICollisionBehavior = {
		let collider = UICollisionBehavior()
		collider.translatesReferenceBoundsIntoBoundary = true
		return collider
	}()
	
	private let itemBehavior : UIDynamicItemBehavior = {
		let behavior = UIDynamicItemBehavior()
		behavior.elasticity = 0.75
		behavior.allowsRotation = true
		return behavior
	}()
	
	override init() {
		super.init()
		addChildBehavior(collider)
		addChildBehavior(itemBehavior)
	}
	
	func addBarrier(path: UIBezierPath, named name: String) {
		collider.removeBoundaryWithIdentifier(name)
		collider.addBoundaryWithIdentifier(name, forPath: path)
	}
	
	func addItem(item: UIDynamicItem) {
		collider.addItem(item)
		itemBehavior.addItem(item)
	}
	
	func removeItem(item: UIDynamicItem) {
		collider.removeItem(item)
		itemBehavior.removeItem(item)
	}

}
