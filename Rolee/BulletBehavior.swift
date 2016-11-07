//
//  BulletBehavior.swift
//  Rolee
//
//  Created by Ammar Polat on 07-11-16.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class BulletBehavior : UIDynamicBehavior {
    
    public var items: [UIDynamicItem] = []
    private let audioPlayer = AudioPlayer()
    
    public var ballDelegate : BallDelegate!
    
    private let bulletBehavior : UIDynamicItemBehavior = {
        let bulletBehavior = UIDynamicItemBehavior()
        bulletBehavior.allowsRotation = true
        bulletBehavior.elasticity = 1
        bulletBehavior.friction = 0
        return bulletBehavior
    }()
    
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
        bulletBehavior.removeItem(item)
    }
    
    func removeItems() {
        for item in items {
            bulletBehavior.removeItem(item)
        }
        items.removeAll()
    }

}
