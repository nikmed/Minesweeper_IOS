//
//  Texture.swift
//  Minesweeper
//
//  Created by Никита Медведев on 21.01.2021.
//

import Foundation
import SpriteKit

func frameSize(texture: SKTexture) -> CGSize
{
    let textSize = texture.size()
    
    let columns = 14
    let rows = 1
    
    let horizontalSpacing = 0
    let verticalSpacing = 0

    return CGSize(
        width: (textSize.width - CGFloat(horizontalSpacing)) / CGFloat(columns),
        height: (textSize.height - CGFloat(verticalSpacing)) / CGFloat(rows)
    )
}

func textureFor(value: Int) -> SKTexture? {
    let texture: SKTexture = SKTexture(imageNamed: "tiles")
    
    let fSize: CGSize = frameSize(texture: texture)
    let textureRect = CGRect(
        x: CGFloat(value) * (fSize.width),
        y: 0,
        width: fSize.width,
        height: fSize.height
    )
    let atlasSize: CGSize = texture.size()
    let normalizedRect = CGRect(
        x: textureRect.origin.x / atlasSize.width,
        y: textureRect.origin.y / atlasSize.height,
        width: fSize.width / atlasSize.width,
        height: fSize.height / atlasSize.height
    )
    
    let newTexture: SKTexture = SKTexture(rect: normalizedRect, in: texture)
    return newTexture
}
