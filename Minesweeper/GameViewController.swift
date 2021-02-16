//
//  GameViewController.swift
//  Minesweeper
//
//  Created by Никита Медведев on 30.01.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene.newGameScene()
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        
        skView.addGestureRecognizer(pinch)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    @objc func handlePinch(sender: UIPinchGestureRecognizer)
    {
        let deltaScale = sender.scale / 1
        let minScale = CGFloat(0.3)
        let maxScale = CGFloat(2)
        
        guard deltaScale > minScale && deltaScale < maxScale else { return }

        scene?.camera?.setScale(deltaScale)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
