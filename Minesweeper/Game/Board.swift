import Foundation
import SpriteKit

class Board
{
    let node: SKShapeNode
    let size: Int
    var bombs: Int
    private var tiles: [[Tile]]
    private var tileSize: CGSize {
        CGSize(
            width: node.frame.width / CGFloat(size),
            height: node.frame.height / CGFloat(size)
        )
    }
    private var numberOfTiles: Int
    {
        size * size
    }
    private var board: [[Int]]
    private var openedBoard: [[Int]]
    init(size: Int, bombs: Int) {
        self.node = SKShapeNode()
        self.node.fillColor = .red
        self.node.strokeColor = .clear
        self.node.position = .zero
        self.size = size
        self.bombs = bombs
        self.tiles = Array(repeating: Array(repeating: Tile.init(value: 9), count: size + 2), count: size + 2)
        self.board = Array(repeating: Array(repeating: 0, count: size + 2), count: size + 2)
        self.openedBoard = Array(repeating: Array(repeating: 0, count: size + 2), count: size + 2)
        
        generateBoard()
    }
    
    private func generateBoard() -> Void
    {
        for i in 1...size{
            for j in 1...size{
                self.board[i][j] = 10
                if Int.random(in: 0..<5) == 0 && bombs > 0{
                    self.openedBoard[i][j] = 11
                    self.bombs -= 1
                }
                else{
                    self.openedBoard[i][j] = 0
                }
            }
        }
        var count = 0
        for i in 1...size{
            for j in 1...size{
                if self.openedBoard[i][j] != 11{
                    for l in -1...1{
                        for k in -1...1{
                            if self.openedBoard[i+l][j+k] == 11{
                                count += 1
                            }
                        }
                    }
                    self.openedBoard[i][j] = count
                    count = 0
                }
                self.tiles[i][j] = Tile(value: openedBoard[i][j])
                node.addChild(self.tiles[i][j].tile)
            }
        }
    }
    
    public func repositionBoard(to boardSize: CGSize) {
        node.path = CGPath(rect: CGRect(x: -boardSize.width/2, y: -boardSize.height/2, width: boardSize.width, height: boardSize.height), transform: nil)

        for i in 1...size{
            for j in 1...size{
                tiles[i][j].tile.size = tileSize

                let x = node.frame.minX + (CGFloat(j) - 0.5) * tileSize.height
                let y = node.frame.maxY - (CGFloat(i) - 0.5) * tileSize.width

                tiles[i][j].tile.position = CGPoint(x: x, y: y)
                tiles[i][j].cordX = x
                tiles[i][j].cordY = y
            }
        }
    }
    
    public func openNearTiles(i: Int, j: Int)
    {
            let p1: Int = i - 1 > 1 ? i - 1 : 1
            let p2: Int = i + 1 > size ? size : i + 1
            let k1: Int = j - 1 > 1 ? j - 1 : 1
            let k2: Int = j + 1 > size ? size : j + 1
            for k in p1...p2{
                for l in k1...k2{
                    if tiles[k][l].openedValue == 0 && !tiles[k][l].isOpened
                    {
                            tiles[k][l].openTile()
                            openNearTiles(i: k, j: l)
                            
                        
                    }
                    
                }
        }
    }
    
    public func gameOver(){
        print("GAME OVER")
        var res: Bool = false
        for tilerow in tiles
        {
            for tile in tilerow
            {
                tile.lastOpen()
            }
        }
    }
    
    public func openTileAt(pos: CGPoint)
    {
        for i in 1...size{
            for j in 1...size{
                if (floor(CGFloat(tiles[i][j].cordX) / tileSize.width) == floor(pos.x / tileSize.width)) &&
                    (floor(CGFloat(tiles[i][j].cordY) / tileSize.height) == floor(pos.y / tileSize.height)){
                    if tiles[i][j].openTile()
                    {
                        gameOver()
                    }
                    else
                    {
                        if tiles[i][j].openedValue == 0
                        {
                           openNearTiles(i: i, j: j)
                        }
                    }
                    
                }
            }
        }
    }
    
    public func flagTileAt(pos: CGPoint)
    {
        for tilerow in tiles
        {
            for tile in tilerow
            {
                if (floor(CGFloat(tile.cordX) / tileSize.width) == floor(pos.x / tileSize.width)) &&
                    (floor(CGFloat(tile.cordY) / tileSize.height) == floor(pos.y / tileSize.height)){
                    tile.flagTile()
                    
                }
            }
        }
    }
    
}
