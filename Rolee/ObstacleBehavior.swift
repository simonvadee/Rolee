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
		push.setAngle( CGFloat(M_PI_2), magnitude: 1)
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
    
    private let holeBehavior : UIDynamicItemBehavior = {
        let behavior2 = UIDynamicItemBehavior()
        behavior2.elasticity = 0
        behavior2.allowsRotation = false
        behavior2.isAnchored = true
        return behavior2
    }()
	
	override init() {
		super.init()
		addChildBehavior(itemBehavior)
        addChildBehavior(holeBehavior)
		addChildBehavior(continuousPush)
	}
	
	func addItem(_ item: UIDynamicItem) {
		itemBehavior.addItem(item)
		itemBehavior.addAngularVelocity(CGFloat(10), for: item)
		continuousPush.addItem(item)
		items.append(item)
	}
    
    func addholeItem(_ item: UIDynamicItem) {
        holeBehavior.addItem(item)
        items.append(item)
    }
	
	func removeItems() {
		for item in items {
			itemBehavior.removeItem(item)
            holeBehavior.removeItem(item)
			continuousPush.removeItem(item)
		}
		items.removeAll()
	}
}
