//
//  GameScene.swift
//  FightNinja
//
//  Created by Shephertz on 19/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode? = nil
    var enemy:SKSpriteNode? = nil
    var isEnemyAdded = false
    
    var bulletsTobeDeleted:NSMutableArray = NSMutableArray()
    
    let playerBulletCategory:UInt32 = 0x1 << 0
    let enemyBulletCategory:UInt32  = 0x1 << 1
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        AppWarpHelper.sharedInstance.gameViewController!.userNameField?.isHidden = true
        AppWarpHelper.sharedInstance.gameViewController!.playAsGuestButton?.isHidden = true
        
        player = SKSpriteNode(imageNamed:"Player")
        let x_player = player!.size.width/2
        player!.position = CGPoint(x:x_player, y:self.frame.midY);
        self.addChild(player!)
        
        
        enemy = SKSpriteNode(imageNamed:"Enemy")
        let x_enemy = self.frame.size.width-enemy!.size.width/2
        enemy!.position = CGPoint(x:x_enemy, y:self.frame.midY);
        self.addChild(enemy!)
        enemy!.alpha = 0.5
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
    //override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
           /**
            * Creating Bullet
            */
            let bullet = SKSpriteNode(imageNamed:"Bullet-red")
            bullet.xScale = 0.5
            bullet.yScale = 0.5
            bullet.name = "2"
            let x_player = player!.size.width/2 + player!.position.x
            bullet.position = CGPoint(x:x_player, y:player!.position.y);
            
            bullet.physicsBody = SKPhysicsBody(circleOfRadius:bullet.size.width/2)
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.categoryBitMask = playerBulletCategory
            bullet.physicsBody?.contactTestBitMask = enemyBulletCategory
            bullet.physicsBody?.collisionBitMask = 0
            bullet.physicsBody?.usesPreciseCollisionDetection = true
           /**
            * Determining offset of location of Bullet
            */
            let offX = location.x - x_player
            let offY = location.y - bullet.position.y
            
            /**
            * Restrict downward and backwards shooting
            */
            if offX <= 0 {return}
            
            /**
            * Adding Bullet to the scene
            */
            self.addChild(bullet)
            
            /**
            * Calculating where to shoot
            */
            let realX = self.frame.width + bullet.frame.width/2
            let ratio = offY / offX
            let realY = realX*ratio + bullet.position.y
            let realDestination = CGPoint(x: realX, y: realY)
            
            /**
            *  Calculating time and distance consumed by the bullet on the shooting path
            */
            let offRealX = realX - bullet.position.x
            let offRealY = realY - bullet.position.y
            let sum = (offRealX * offRealX)+(offRealY * offRealY)
            let length = sqrt(sum)
            let velocity = self.frame.width/1
            let realTimeDuration = length/velocity
            
            let destination = CGPoint(x: self.frame.width-realX, y: realY)
            let dataDict = NSMutableDictionary()
            dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "userName" as NSCopying)
            //dataDict.setObject(NSValue(CGPoint: destination), forKey: "projectileDest")
            let destStr:String = NSStringFromCGPoint(destination)
            dataDict.setObject(destStr, forKey: "projectileDest" as NSCopying)
            
            let playerPosition:String = NSStringFromCGPoint(destination)
            dataDict.setObject(playerPosition, forKey: "playerPosition" as NSCopying)

            dataDict.setObject(NSString(format: "%lf", realTimeDuration.native), forKey: "realMoveDuration" as NSCopying)//(String(realTimeDuration.native), forKey: "realMoveDuration")
            AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict: dataDict)
            /**
            * Shoot the bullet
            */
            let shootAction = SKAction.move(to: realDestination, duration:realTimeDuration.native)
            let actionFinish = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([shootAction,actionFinish]))
        }
    }
    
    func updateEnemyStatus(_ dataDict: NSDictionary)
    {
        print("updateEnemyStatus...1")

        //playerPositon
        let count = dataDict.count
        if count < 2
        {
            return
        }
        enemy!.alpha = 1.0
        isEnemyAdded = true
        
       /**
        * Creating Bullet
        */
        let bullet = SKSpriteNode(imageNamed:"Bullet-blue")
        bullet.xScale = 0.5
        bullet.yScale = 0.5
        //bullet.name = "1"
        let x_enemy = enemy!.position.x - enemy!.size.width/2
        bullet.position = CGPoint(x:x_enemy, y:enemy!.position.y);
        
        /**
        * Adding physics body to the bullet
        */
        bullet.physicsBody = SKPhysicsBody(circleOfRadius:bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = enemyBulletCategory
        bullet.physicsBody?.contactTestBitMask = playerBulletCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        /**
        * Adding Bullet to the scene
        */
        self.addChild(bullet)
        
        /**
        * Shoot the bullet
        */
        let realMoveDuration = dataDict.object(forKey: "realMoveDuration") as! String
        let actualDuration = NSString(string: realMoveDuration).doubleValue //(NSTimeInterval)(realMoveDuration.bridgeToObjectiveC().floatValue)
        let value = dataDict.object(forKey: "projectileDest") as! String
        let destination = CGPointFromString(value)
        
        let shootAction = SKAction.move(to: destination, duration: actualDuration)
        let actionFinish = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([shootAction,actionFinish]))
    }
    
    func bulletsDidCollide()
    {
        //playerBullet.removeFromParent()
        //enemyBullet.removeFromParent()
        for index in stride(from: (bulletsTobeDeleted.count - 1), through: 0, by: -1) {
            let bullet:SKSpriteNode = bulletsTobeDeleted.object(at: index) as! SKSpriteNode;
            bullet.removeFromParent()
            bulletsTobeDeleted.remove(bullet);
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    /**
    * Collision Delegates
    */
    func didBegin(_ contact: SKPhysicsContact)
    {
        var firstBullet:SKPhysicsBody
        var secondBullet:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBullet = contact.bodyA;
            secondBullet = contact.bodyB;
        }
        else
        {
            firstBullet = contact.bodyB;
            secondBullet = contact.bodyA;
        }
        
        if ((firstBullet.categoryBitMask & playerBulletCategory) != 0 &&
            (secondBullet.categoryBitMask & enemyBulletCategory) != 0)
        {
            if !bulletsTobeDeleted.contains(firstBullet.node!)
            {
                bulletsTobeDeleted.add(firstBullet.node!)
            }
            if !bulletsTobeDeleted.contains(secondBullet.node!)
            {
                bulletsTobeDeleted.add(secondBullet.node!)
            }
            //self.bulletsDidCollide()
        }
    }
}
