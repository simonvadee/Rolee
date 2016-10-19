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
	private var snap: UISnapBehavior! {
		didSet {
			snap.damping = 1
			addChildBehavior(snap)
		}
	}
		
	private let customBehavior: UIDynamicItemBehavior = {
		let behavior = UIDynamicItemBehavior()
		behavior.allowsRotation = false
		return behavior
	}()
	
	override init() {
		super.init()
		addChildBehavior(customBehavior)
	}

	func addItem(_ item: UIDynamicItem) {
		ball = item as? UIView
		customBehavior.addItem(ball!)
		snap = UISnapBehavior(item: ball!, snapTo: CGPoint.zero)
	}
	
	func removeItem(_ item: UIDynamicItem) {
		customBehavior.removeItem(ball!)
		if (snap != nil) {
			removeChildBehavior(snap!)
		}
	}
	
	func snapBall(_ dest: CGPoint) {
		if (snap != nil) {
			removeChildBehavior(snap!)
		}
		snap = UISnapBehavior(item: ball!, snapTo: dest)
	}
	
}

