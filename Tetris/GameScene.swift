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
	let timeCycle = 20
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
	
	fileprivate func deleteTetrisTile() {
		let blocks = movingTile.children
		for block in blocks {
			block.move(toParent: self)
		}
		movingTile.removeFromParent()
	}
	
	func move() {
		movingTile.position.y -= grid.dy // move Tetris Tile Down
	}
	
	var lastTouchedLocation : CGPoint?
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let location = touches.first?.location(in: self) {
			lastTouchedLocation = location
		}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let location = touches.first?.location(in: self) {
			if let lastPos = lastTouchedLocation {
				
				let dx = CGFloat(Int((location.x - lastPos.x) / grid.dx)) * grid.dx
//				let dy = CGFloat(Int((location.y - lastPos.y) / grid.dy)) * grid.dy
				let newPos = movingTile.position.applying(CGAffineTransform(translationX: dx, y: 0))
				
				if dx > 0 && !collisionWithBlock(inDir: .right) {
						movingTile.position = newPos
				} else if dx < 0 && !collisionWithBlock(inDir: .left) {
						movingTile.position = newPos
				}
				
				
				lastTouchedLocation = location
			}
		}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchedLocation = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchedLocation = nil
    }
	
	var staleBlocks : [SKNode] {
		get { return self.children.filter({!$0.isEqual(movingTile)}) }
	}
	
	func collisionWithBlockOrFrame() -> Bool {
		return (collisionWithFrame() || collisionWithBlock(inDir: .down))
	}
	
	enum Direction {
		case down,left,right
	}
	
	func collisionWithBlock(inDir: Direction) -> Bool {
		let movingBlocks = movingTile.children
		
		for block in movingBlocks {
			let globalPos = movingTile.convert(block.position, to: self)
			let blockRow = grid.row(from: globalPos)
			let blockCol = grid.col(from: globalPos)
			
			for staleBlock in staleBlocks {
				let staleBlockRow = grid.row(from: staleBlock.position)
				let staleBlockCol = grid.col(from: staleBlock.position)
				
				var direction: [Int]
				
				switch inDir {
				case .down:
					direction = [0,1]
				case .left:
					direction = [-1,0]
				case .right:
					direction = [1,0]
				}
				
				if staleBlockRow + direction[0] == blockRow && staleBlockCol + direction[1] == blockCol {
					return true
				}
			}
		}
		return false
	}
	
	
	func collisionWithFrame () -> Bool {
		let movingBlocks = movingTile.children
		for block in movingBlocks {
			let globalPos = movingTile.convert(block.position, to: self)
			let blockHitFrame = globalPos.y <= view!.frame.minY + grid.cellHeight
			
			if blockHitFrame {
				return true
			}
			
		}
		return false
	}
	
	
    override func update(_ currentTime: TimeInterval) {
		elapsedTime += 1
		if elapsedTime > timeCycle {
			elapsedTime = 0
			cycles += 1
			if collisionWithBlockOrFrame() {
				deleteTetrisTile()
				createTetris()
			} else {
				move()
			}
		}
    }
}
