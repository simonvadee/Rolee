//
//  ObstacleBehavior.swift
//  Rolee
//
//  Created by simon vadée on 07/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class ObstacleBehavior: UIDynamicBehavior {

	private var items: [UIDynamicItem] = []
	
	private let continuousPush: UIPushBehavior = {
		let push = UIPushBehavior(items: [], mode: .continuous)
		push.setAngle( CGFloat(M_PI_2), magnitude: 6)
		push.action = {
			push.angle =  -push.angle
		}
		return push
	}()
		
	private let itemBehavior : UIDynamicItemBehavior = {
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
		items.append(item)
	}
	
	func removeItems() {
		for item in items {
			itemBehavior.removeItem(item)
			continuousPush.removeItem(item)
		}
		items.removeAll()
	}

}
