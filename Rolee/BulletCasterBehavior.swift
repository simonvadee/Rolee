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
    private let audioPlayer = AudioPlayer()
    private var item : UIDynamicItem? = nil
    
    public var ballDelegate : BallDelegate!
    
    private let bulletCasterBehavior : UIDynamicItemBehavior = {
        let casterbehavior = UIDynamicItemBehavior()
        casterbehavior.allowsRotation = true
        casterbehavior.isAnchored = true
        casterbehavior.elasticity = 0
        return casterbehavior
    }()
    
    private let bulletBehavior : UIDynamicItemBehavior = {
        let bulletBehavior = UIDynamicItemBehavior()
        bulletBehavior.allowsRotation = true
        bulletBehavior.elasticity = 1
        bulletBehavior.friction = 0
        return bulletBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(bulletCasterBehavior)
        addChildBehavior(bulletBehavior)
    }
    
    func addBulletCaster(_ item: UIDynamicItem) {
        bulletCasterBehavior.addItem(item)
        bulletCasterBehavior.addAngularVelocity(CGFloat(10), for: item)
        items.append(item)
    }
    
    func addBullet(_ item : UIDynamicItem) {
        let pushBehavior = UIPushBehavior()
        pushBehavior.pushDirection = CGVector(dx: ballDelegate.getBallPosition().x - item.center.x, dy: ballDelegate.getBallPosition().y - item.center.y)
        addChildBehavior(pushBehavior)
    
        pushBehavior.addItem(item)
        bulletBehavior.addItem(item)
        audioPlayer.loadAudioFileNamed(fileName: "firing", fileExtension: "mp3")
        audioPlayer.playSound()
        items.append(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        bulletCasterBehavior.removeItem(item)
    }
    
    func removeItems() {
        for item in items {
            bulletCasterBehavior.removeItem(item)
            bulletBehavior.removeItem(item)
        }
        items.removeAll()
    }
}

