//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var motionManager = CMMotionManager()
    
    static var level = 1
    
    private var recognizer: UITapGestureRecognizer!
    
    internal var collider: UICollisionBehavior!
    internal var animator: UIDynamicAnimator!
    
    private var startTime: DispatchTime!
    private var endTime: DispatchTime!
    private var score: Double!
    
    @IBOutlet weak var gameScene: GameScene! {
        didSet {
            self.recognizer = UITapGestureRecognizer(target: gameScene, action:#selector(GameScene.snapBall(_:)))
            
            self.animator = UIDynamicAnimator(referenceView: gameScene)
            self.animator.delegate = self
            
            self.collider = UICollisionBehavior()
            self.collider.collisionDelegate = self
            self.collider.translatesReferenceBoundsIntoBoundary = true
            
            self.animator.addBehavior(collider)
            
            gameScene.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        motionManager.accelerometerUpdateInterval = 0.03
        
        //Start Recording Data
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            self.movePlayer(acceleration: accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
    }
    
    func movePlayer(acceleration: CMAcceleration){
        
        //Positive horizontal movement
        if(acceleration.x > 0.1) {
            gameScene.ball.center.x += 2
            if(acceleration.x > 0.3) {
                gameScene.ball.center.x += 4
                if (acceleration.x > 0.6) {
                    gameScene.ball.center.x += 6
                }
            }
        }
        
        //Negative horizontal movement
        if(acceleration.x < -0.1) {
            gameScene.ball.center.x -= 2
            if(acceleration.x < -0.3) {
                gameScene.ball.center.x -= 4
                if (acceleration.x < -0.6) {
                    gameScene.ball.center.x -= 6
                }
            }
        }
        
        //Positive vertical movement
        if(acceleration.y < -0.1) {
            gameScene.ball.center.y += 2
            if(acceleration.y < -0.3) {
                gameScene.ball.center.y += 4
                if (acceleration.y < -0.6) {
                    gameScene.ball.center.y += 6
                }
            }
        }
        
        //Negative vertical movement
        if(acceleration.y > 0.1) {
            gameScene.ball.center.y -= 2
            if(acceleration.y > 0.3) {
                gameScene.ball.center.y -= 4
                if (acceleration.y > 0.6) {
                    gameScene.ball.center.y -= 6
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-game.png")!)
        super.viewWillAppear(animated)
        gameScene.addGestureRecognizer(self.recognizer)
        
        addBehaviorToAnimator(collider)
        gameScene.initScene()
        gameScene.animating = true
        
        self.score = 0
        self.startTime = DispatchTime.now()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        gameScene.removeGestureRecognizer(recognizer)
        
        for item in collider.items {
            removeItemFromCollider(item as! UIView)
        }
        
        removeBehaviorFromAnimator(collider)
        gameScene.animating = false
        
        gameScene.emptyScene()
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior,
                           beganContactFor item1: UIDynamicItem,
                           with item2: UIDynamicItem,
                           at: CGPoint) {
        let firstItem = (item1 as? UIView)!.tag
        let secondItem = (item2 as? UIView)!.tag
        switch (firstItem, secondItem) {
        // collision between ball and exit
        case (0, -1), (-1, 0):
            self.endTime = DispatchTime.now()
            self.score = computeScore()
            performSegue(withIdentifier: "winSegue", sender: self)
        // collision between ball and obstacle
        case (0, _), (_, 0):
            performSegue(withIdentifier: "loseSegue", sender: self)
        // collision between obstacles and/or exit
        default:
            break
        }
    }
    
    func computeScore() -> Double {
        let levelTime = (endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 100_000_000
        return (1000 / Double(levelTime))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let _ = segue.destination as! EndLevelViewController
        
        switch (segue.identifier!) {
        case "winSegue":
            EndLevelViewController.score += self.score
        case "loseSegue":
            break
        default:
            break
        }
    }
}

extension GameViewController : UIDynamicAnimatorDelegate, GameSceneDelegate {
    internal func removeItemFromCollider(_ item: UIView) {
        collider.removeItem(item)
    }
    
    internal func addItemToCollider(_ item: UIView) {
        collider.addItem(item)
    }
    
    internal func removeBehaviorFromAnimator(_ behavior: UIDynamicBehavior) {
        animator.removeBehavior(behavior)
    }
    
    internal func addBehaviorToAnimator(_ behavior: UIDynamicBehavior) {
        animator.addBehavior(behavior)
    }
}

protocol GameSceneDelegate {
    func addItemToCollider(_ item: UIView)
    func removeItemFromCollider(_ item: UIView)
    func addBehaviorToAnimator(_ behavior: UIDynamicBehavior)
    func removeBehaviorFromAnimator(_ behavior: UIDynamicBehavior)
}
