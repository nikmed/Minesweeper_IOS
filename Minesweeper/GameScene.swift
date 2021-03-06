//
//  GameScene.swift
//  Minesweeper
//
//  Created by Никита Медведев on 30.01.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var board: Board!
    var firstPressTime: TimeInterval!
    var time: TimeInterval!
    var longTouchPosition: CGPoint!
    var longPressStart: Bool = false
    
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: 0)
        scene.addChild(cameraNode)
        scene.camera = cameraNode
        
        return scene
    }
    
    func setUpScene() {
        board = Board(size: 20, bombs: 99)
        addChild(board.node)
        repositionBoard()
        
    }

    func repositionBoard() {
        guard board != nil else { return }
        let margin: CGFloat = 0
        let dimension = min(size.width, size.height) - 2*margin
        board.repositionBoard(to: CGSize(width: dimension, height: dimension))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        firstPressTime = time
        longTouchPosition = pos
        longPressStart = true
    }
    
    
    func touchMoved(toPoint pos : CGPoint) {
        let oldPos = scene?.camera?.position ?? CGPoint(x: 0, y: 0)
        let newPos = CGPoint(x: longTouchPosition.x - pos.x, y: longTouchPosition.y - pos.y)
        scene?.camera?.position = CGPoint(x: (oldPos.x + newPos.x), y: (oldPos.y + newPos.y))
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if (time - firstPressTime < 0.3)
        {
            if pos == longTouchPosition {
                board.openTileAt(pos: pos)
            }
        }
        longPressStart = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func didChangeSize(_ oldSize: CGSize) {
        repositionBoard()
    }
    
    override func didMove(to view: SKView) {
        
        self.setUpScene()
    }

    override func update(_ currentTime: TimeInterval) {
        time = currentTime
        if (longPressStart) && (currentTime - firstPressTime > 0.3) 
        {
            board.flagTileAt(pos: longTouchPosition)
            longPressStart = false
        }
    }
    
}
