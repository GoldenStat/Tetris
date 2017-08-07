//
//  GameScene.swift
//  Tetris
//
//  Created by Alexander Völz on 31.07.17.
//  Copyright © 2017 Alexander Völz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	var movingTile: TetrisNode!
	var elapsedTime: Int = 0
	let timeCycle = 2
	let grid = TetrisGrid()
	var cycles = 0
	
	// pointers for later
	var previewWindow: UIView?
	var nextTile: TetrisNode?
	var walls: SKSpriteNode?
	var score: Int = 0
	
    override func didMove(to view: SKView) {
		grid.prepare(for: view.bounds)
		anchorPoint = CGPoint(x: 0, y: 0)		
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		createTetris()
	}
	
	fileprivate func centerTileAtTop(_ tetris: TetrisNode) {
		let topCenter = grid.nearest(point: CGPoint(x: size.width / 2.0 , y: size.height - grid.cellHeight * 2 ))
		let pointAdjustedForSKNodeCenter = CGPoint(x: topCenter.x - grid.cellWidth / 2.0, y: topCenter.y - grid.cellHeight / 2.0)
		tetris.position = pointAdjustedForSKNodeCenter
	}
	
	func createTetris() {
		let randomTile = GKRandomSource.sharedRandom().nextInt(upperBound: TetrisNode().numberOfTypes)
		let tetris = TetrisNode()
		tetris.create(tile: randomTile, for: grid)
		centerTileAtTop(tetris)
		addChild(tetris)
		movingTile = tetris
	}
	
	fileprivate func deleteTetrisTile(_ tetrisTile: TetrisNode) {
		let blocks = tetrisTile.children
		for block in blocks {
			block.move(toParent: self)
		}
		tetrisTile.removeFromParent()
	}
	
	func move(movingTile: TetrisNode) {
		movingTile.position.y -= grid.dy // move Tetris Tile Down
	}
	
	
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
	}
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
	
	func collisionWithBlockOrFrame(tile: TetrisNode) -> Bool {
		let movingBlocks = tile.children
		let staleBlocks = self.children.filter({!$0.isEqual(tile)})
		
		for block in movingBlocks {
			let globalPos = tile.convert(block.position, to: self)
			let blockHitFrame = globalPos.y <= view!.frame.minY + grid.cellHeight
			let blockRow = grid.row(from: globalPos)
			
			if blockHitFrame {
				return true
			} else {
				for staleBlock in staleBlocks {
					let staleBlockRow = grid.row(from: staleBlock.position)
					let blockHitBlock = staleBlockRow + 1 == blockRow && grid.col(from: staleBlock.position) == grid.col(from: globalPos)
					if blockHitBlock {
						return blockHitBlock
					}
				}
			}
		}
		
		return false
	}
    
    override func update(_ currentTime: TimeInterval) {
		elapsedTime += 1
		if elapsedTime > timeCycle {
			elapsedTime = 0
			cycles += 1
			move(movingTile: movingTile)
			if collisionWithBlockOrFrame(tile: movingTile) {
				deleteTetrisTile(movingTile)
				createTetris()
			}
		}
    }
}
