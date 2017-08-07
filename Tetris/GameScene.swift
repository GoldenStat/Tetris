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
	let timeCycle = 10
	let grid = TetrisGrid()
	var cycles = 0
	var gameLabel = SKLabelNode()
	var scoreLabel = SKLabelNode(text: "Score: 0")
	
	enum GameState {
		case running, paused, over
	}
	
	var gameState : GameState = .paused
	
	// pointers for later
	var previewWindow: UIView?
	var nextTile: TetrisNode?
	var walls: SKSpriteNode?
	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
    override func didMove(to view: SKView) {
		grid.prepare(for: size)
		anchorPoint = CGPoint(x: 0, y: 0)		
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		createTetris()
		makeLabels()
	}
	
	func makeLabels() {
		makeGameLabel()
		makeScoreLabel()
	}
	
	func makeGameLabel() {
		gameLabel.fontName = "Chalkduster"
		gameLabel.fontSize = 64
		gameLabel.color = UIColor.white
		gameLabel.position = CGPoint(x: size.width / 2.0 , y: size.height - grid.cellHeight * 10.0 )
		gameLabel.isHidden = true
		addChild(gameLabel)
	}
	
	func makeScoreLabel() {
		scoreLabel.fontName = "Chalkduster"
		scoreLabel.fontSize = 32
		scoreLabel.color = UIColor.white
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: size.width * 7.0 / 10.0 , y: size.height - grid.cellHeight * 3 )
		score = 0
		
		addChild(scoreLabel)
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
		if collisionWithBlock(in: .down) {
			gameState = .over
		}
		score += 1
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
		if gameState == .running {
			if let location = touches.first?.location(in: self) {
				if let lastPos = lastTouchedLocation {
					
					var dx = Int((location.x - lastPos.x) / grid.dx)
					var dy = Int((location.y - lastPos.y) / grid.dy)
					
					
					if dx > 0 {
						while !collisionWithBlockOrFrame(in: .right) && dx > 0 {
							let newPos = movingTile.position.applying(CGAffineTransform(translationX: grid.dx, y: 0))
							movingTile.position = newPos
							dx -= 1
						}
					} else if dx < 0 {
						while !collisionWithBlockOrFrame(in: .left) && dx < 0 {
							let newPos = movingTile.position.applying(CGAffineTransform(translationX: -grid.dx, y: 0))
							movingTile.position = newPos
							dx += 1
						}
					} else if dy < 0 {
						while !collisionWithBlockOrFrame(in: .down) && dy < 0 {
							let newPos = movingTile.position.applying(CGAffineTransform(translationX: 0, y: -grid.dy))
							movingTile.position = newPos
							dy += 1
						}
						
					}
					
					lastTouchedLocation = location
				}
			}
		}
	}
	
	func reset() {
		gameState = .running
		score = 0
		removeAllChildren()
		createTetris()
	}
	
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		switch gameState {
		case .over:
			reset()
			gameState = .running
		case .paused:
			gameState = .running
		case .running:
			if let _ = lastTouchedLocation, let endLocation = touches.first?.location(in: self) {
				if endLocation.equalTo(lastTouchedLocation!) {
					let rotate = SKAction.rotate(byAngle: CGFloat.pi / 2.0, duration: 0.001)
					movingTile.run(rotate)
				}
			}
		}
		lastTouchedLocation = nil
		
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchedLocation = nil
    }
	
	override func willMove(from view: SKView) {
		gameState = .paused
	}
	
	var staleBlocks : [SKNode] {
		get { return self.children.filter({$0.isKind(of: Block.self)}) }
	}
	
	func collisionWithBlockOrFrame(in dir: Direction) -> Bool {
		return (collisionWithFrame(in: dir) || collisionWithBlock(in: dir))
	}
	
	enum Direction {
		case down,left,right, rotate
	}
	
	func rotate(to dir: Direction) {
		switch dir {
		case .right:
			let rotateRight = SKAction.rotate(byAngle: CGFloat.pi / 2.0, duration: 0.001)
			movingTile.run(rotateRight) { [ weak movingTile, grid ] in
				if let pos = movingTile?.position {
					movingTile?.position = grid.nearest(point: pos)
				}
			}
		case .left:
			let rotateLeft = SKAction.rotate(byAngle: -CGFloat.pi / 2.0, duration: 0.001)
			movingTile.run(rotateLeft) { [ weak movingTile, grid ] in
				if let pos = movingTile?.position {
					movingTile?.position = grid.nearest(point: pos)
				}
			}
		default:
			break
		}
	}
	
	func collisionWithBlock(in dir: Direction) -> Bool {
		
		var direction: [Int]
		
		switch dir {
		case .down:
			direction = [0,-1]
		case .left:
			direction = [-1,0]
		case .right:
			direction = [1,0]
		case .rotate:
			rotate(to: .right)
			direction = [0,0]
		}
		
		let movingBlocks = movingTile.children
		
		for block in movingBlocks {
			
			let globalPos = movingTile.convert(block.position, to: self)
			let blockRow = grid.row(from: globalPos)
			let blockCol = grid.col(from: globalPos)
			
			for staleBlock in staleBlocks {
				let checkPos = staleBlock.position
				let staleBlockRow = grid.row(from: checkPos)
				let staleBlockCol = grid.col(from: checkPos)
				
				if staleBlockRow == blockRow + direction[1]  &&
					staleBlockCol == blockCol + direction[0] {
					if dir == .rotate {
						rotate(to: .left)
					}
					return true
				}
			}
		}
		return false
	}
	
	
	func collisionWithFrame(in dir: Direction) -> Bool {
		let movingBlocks = movingTile.children
		var frameHit = false
		
		for block in movingBlocks {
			let globalPos = movingTile.convert(block.position, to: self)
			switch dir {
			case .left:
				frameHit = globalPos.x <= grid.cellWidth
			case .right:
				frameHit = globalPos.x + grid.cellWidth >= size.width
			case .down:
				frameHit = globalPos.y <= grid.cellHeight
			case .rotate:
				break
			}
			if frameHit {
				return true
			}
		}
		return false
	}
	
	func updateLabel() {
		switch gameState {
		case .running:
			gameLabel.isHidden = true
		case .over:
			gameLabel.isHidden = false
			gameLabel.text = "Game Over"
		case .paused:
			gameLabel.isHidden = false
			gameLabel.text = "Paused"
		}
	}
	
    override func update(_ currentTime: TimeInterval) {
		updateLabel()
		
		if gameState == .running {
			elapsedTime += 1
			if elapsedTime > timeCycle {
				elapsedTime = 0
				cycles += 1
				if collisionWithBlockOrFrame(in: .down) {
					deleteTetrisTile()
					createTetris()
				} else {
					move()
				}
			}
		}
    }
}
