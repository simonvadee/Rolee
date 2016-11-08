//
//  BulletBehavior.swift
//  Rolee
//
//  Created by Ammar Polat on 05-11-16.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class BulletCasterBehavior : UIDynamicBehavior {
    
    public var items: [UIDynamicItem] = []
    
    public var ballDelegate : BallDelegate!
    
    private let bulletCasterBehavior : UIDynamicItemBehavior = {
        let casterbehavior = UIDynamicItemBehavior()
        casterbehavior.allowsRotation = true
        casterbehavior.isAnchored = true
        casterbehavior.elasticity = 0
        return casterbehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(bulletCasterBehavior)
    }
    
    func addBulletCaster(_ item: UIDynamicItem) {
        bulletCasterBehavior.addItem(item)
        items.append(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        bulletCasterBehavior.removeItem(item)
    }
    
    func removeItems() {
        for item in items {
            bulletCasterBehavior.removeItem(item)
        }
        items.removeAll()
    }
}
