//
//  GameViewController.swift
//  BreakoutSpriteKitTutorial
//
//  Created by ZhouHao on 9/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Configure the view.
        let skView = self.view as SKView
        if (!skView.scene) {
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            // Create and configure the scene.
            let scene = MyScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
            
            // Present the scene.
            skView.presentScene(scene)
        }
    }
/*
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
