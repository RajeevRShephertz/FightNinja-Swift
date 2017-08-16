//
//  GameViewController.swift
//  FightNinja
//
//  Created by Shephertz on 19/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit
import SpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        
        let path = Bundle.main.path(forResource: file as String, ofType: "sks")
        
        let sceneData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet var userNameField: UITextField?
    @IBOutlet var playAsGuestButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appWarpHelper = AppWarpHelper.sharedInstance
        appWarpHelper.initializeWarp()
        appWarpHelper.gameViewController = self
        
    }

    func startGameScene()
    {
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            AppWarpHelper.sharedInstance.gameScene = scene
            skView.presentScene(scene)
        }
    }
    
    @IBAction func playAsGuest(_: AnyObject)
    {
        userNameField?.resignFirstResponder()
        
        let uName = userNameField?.text
        let uNameLength = uName?.lengthOfBytes(using: String.Encoding.utf8)
        if uNameLength>0
        {
            let appWarpHelper = AppWarpHelper.sharedInstance
            appWarpHelper.playerName = uName!
            appWarpHelper.connectWithAppWarpWithUserName(userName: uName!)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
