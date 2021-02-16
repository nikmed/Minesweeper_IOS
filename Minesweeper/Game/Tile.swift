//
//  Tile.swift
//  Minesweeper
//
//  Created by Никита Медведев on 19.01.2021.
//

import Foundation
import SpriteKit

class Tile
{
    let closedValue: Int = 9
    var openedValue: Int
    var isFlaged: Bool = false
    var isOpened: Bool = false
    var isBomb: Bool
    var gameOver: Bool = false
    var tile: SKSpriteNode
    var cordX: CGFloat
    var cordY: CGFloat
    init(value: Int) {
        self.tile = SKSpriteNode()
        self.tile.color = .blue
        self.tile.anchorPoint = CGPoint(x: 0, y: 1.0)
        self.cordX = 0
        self.cordY = 0
        self.openedValue = value
        self.isBomb = (value == 11)
        self.tile = SKSpriteNode(texture: textureFor(value: self.closedValue))
    }
    
    public func setCoord(pos: CGPoint)
    {
        cordX = pos.x
        cordY = pos.y
        tile.position = CGPoint(x: cordX, y: cordY)
    }
    
    public func flagTile() -> Bool
    {
        if !gameOver{
            if isFlaged{
                self.tile.texture = textureFor(value: 9)
            }
            else{
                self.tile.texture = textureFor(value: 10)
            }
            isFlaged = !isFlaged
        }
        return isFlaged
    }
    
    public func openTile() -> Bool
    {
        if !isFlaged && !gameOver{
            if isBomb{
                if isFlaged{
                    self.tile.texture = textureFor(value: self.openedValue + 2)
                }
                else{
                    self.tile.texture = textureFor(value: self.openedValue + 1)
                }
            }
            else{
                self.tile.texture = textureFor(value: self.openedValue)
            }
        }
        isOpened = true
        return isBomb
    }
    
    public func lastOpen() -> Void
    {
        gameOver = true
        if isBomb{
            if isFlaged{
                self.tile.texture = textureFor(value: self.openedValue + 2)
            }
            else{
                self.tile.texture = textureFor(value: self.openedValue + 1)
            }
        }
        else{
            self.tile.texture = textureFor(value: self.openedValue)
        }
    }
}
