//
//  GameScene.swift
//  Tetris
//
//  Created by Alexander Völz on 31.07.17.
//  Copyright © 2017 Alexander Völz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
    override func didMove(to view: SKView) {
		anchorPoint = CGPoint(x: 0, y: 0)
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		createTetris()
		physicsWorld.contactDelegate = self
    }
	
	func createTetris() {
		let randomTile = GKRandomSource.sharedRandom().nextInt(upperBound: TetrisNode().numberOfTypes)
		let tetris = TetrisNode()
		tetris.create(tile: randomTile)
		tetris.position = CGPoint(x: size.width / 2.0 , y: size.height - Block.const().size * 2.5 )
		addChild(tetris)
		tetris.physicsBody!.contactTestBitMask = tetris.physicsBody!.collisionBitMask
		
	}
	
	func createBlock() {
		let block = Block()
		block.prepare()
		let colors : [UIColor] = [.red, .green, .white, .yellow, .gray]
		block.color = colors[GKRandomSource.sharedRandom().nextInt(upperBound: 5)]
		block.position = CGPoint(x: size.width / 2.0 , y: size.height - Block.const().size * 2.5 )
		let moveBlock = SKAction.move(by: CGVector(dx: 0.0, dy: -32.0), duration: 0.1)
		block.run(SKAction.repeatForever(moveBlock))
		addChild(block)
		block.physicsBody!.contactTestBitMask = block.physicsBody!.collisionBitMask
		
	}
	
	fileprivate func deleteTetrisTile(_ tetrisTile: TetrisNode) {
		let blocks = tetrisTile.children
		for block in blocks {
			block.move(toParent: self)
			block.physicsBody?.isDynamic = true
		}
		tetrisTile.removeFromParent()
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
    
    
    override func update(_ currentTime: TimeInterval) {

    }
}
