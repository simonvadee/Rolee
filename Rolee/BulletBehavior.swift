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
	
	private let pushBehavior : UIPushBehavior = {
		let push = UIPushBehavior(items: [], mode: .continuous)
//		push.setAngle( CGFloat(M_PI_2), magnitude: 1)
//		push.pushDirection = CGVector(dx: ballDelegate.getBallPosition().x - item.center.x, dy: ballDelegate.getBallPosition().y - item.center.y)
//		push.pushDirection = CGVector(dx:100, dy: 100)
		return push
	}()
	
    private let bulletBehavior : UIDynamicItemBehavior = {
        let bulletBehavior = UIDynamicItemBehavior()
		bulletBehavior.elasticity = 1
		return bulletBehavior
    }()

	override init() {
		super.init()
		addChildBehavior(bulletBehavior)
		addChildBehavior(pushBehavior)
	}
	
    func addBullet(_ item : UIDynamicItem) {
		pushBehavior.pushDirection = CGVector(dx:-2, dy:0)
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
