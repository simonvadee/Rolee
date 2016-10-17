//
//  ObstacleBehavior.swift
//  Rolee
//
//  Created by simon vadée on 07/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class ObstacleBehavior: UIDynamicBehavior {

	fileprivate let continuousPush: UIPushBehavior = {
		let push = UIPushBehavior(items: [], mode: .continuous)
		push.setAngle( CGFloat(M_PI_2), magnitude: 1)
		push.action = {
			push.angle =  -push.angle
		}
		return push
	}()
	
	var collider: UICollisionBehavior? {
		didSet {
			addChildBehavior(collider!)
		}
	}
	
	fileprivate let itemBehavior : UIDynamicItemBehavior = {
		let behavior = UIDynamicItemBehavior()
		behavior.elasticity = 1
		behavior.allowsRotation = true
		return behavior
	}()
	
	override init() {
		super.init()
		addChildBehavior(itemBehavior)
		addChildBehavior(continuousPush)
	}
	
	func addItem(_ item: UIDynamicItem) {
		itemBehavior.addItem(item)
		continuousPush.addItem(item)
	}
	
	func removeItem(_ item: UIDynamicItem) {
		itemBehavior.removeItem(item)
		continuousPush.removeItem(item)
	}

}
