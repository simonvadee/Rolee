//
//  BulletBehavior.swift
//  Rolee
//
//  Created by Ammar Polat on 07-11-16.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class BulletBehavior : UIDynamicBehavior {
    
    public var items : [UIDynamicItem] = []
    private let audioPlayer = AudioPlayer()
    
    public var ballDelegate : BallDelegate!
	
	private let pushBehavior : UIPushBehavior = {
		let push = UIPushBehavior(items: [], mode: .continuous)
		return push
	}()
	
    private let bulletBehavior : UIDynamicItemBehavior = {
        let bulletBehavior = UIDynamicItemBehavior()
		bulletBehavior.elasticity = 1
        bulletBehavior.resistance = 1500
		return bulletBehavior
    }()

	override init() {
		super.init()
		addChildBehavior(bulletBehavior)
		addChildBehavior(pushBehavior)
	}
	
    func addBullet(_ item : UIDynamicItem) {
        let xpos = ballDelegate.getBallPosition().x - item.center.x
        let ypos = ballDelegate.getBallPosition().y - item.center.y
        pushBehavior.pushDirection = CGVector(dx: xpos, dy: ypos)
		pushBehavior.addItem(item)
        bulletBehavior.addItem(item)
        audioPlayer.loadAudioFileNamed(fileName: "firing", fileExtension: "mp3")
        audioPlayer.playSound()
        items.append(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        bulletBehavior.removeItem(item)
        pushBehavior.removeItem(item)
    }
    
    func removeItems() {
        for item in items {
            bulletBehavior.removeItem(item)
            pushBehavior.removeItem(item)
        }
        items.removeAll()
    }
}
