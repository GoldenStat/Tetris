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
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
		physicsWorld.contactDelegate = self
		anchorPoint = CGPoint(x: 0, y: 0)
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		createTetris()
    }
	
	func createTetris() {
		let randomTile = GKRandomSource.sharedRandom().nextInt(upperBound: TetrisNode().numberOfTypes)
		let tetris = TetrisNode()
		tetris.create(tile: randomTile)
		tetris.position = CGPoint(x: size.width / 2.0 , y: size.height - Block.const().size * 2.5 )
		addChild(tetris)
		tetris.physicsBody!.contactTestBitMask = tetris.physicsBody!.collisionBitMask
		
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		if contact.bodyA.node?.name == "movingTetrisTile" {
			collisionBetween(tetrisTile: contact.bodyA.node!, object: contact.bodyB.node!)
		} else if contact.bodyB.node?.name == "structure" {
			collisionBetween(tetrisTile: contact.bodyB.node!, object: contact.bodyA.node!)
		}
	}
	
	func collisionBetween(tetrisTile: TetrisNode, object: SKNode) {
		let blocks = tetrisTile.children
		for block in blocks {
			block.physicsBody?.isDynamic = false
		}
	}
	
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
	}
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		createTetris()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//		for tetris in children.flatMap({ $0 as? TetrisNode }) {
//			if tetris.position.y <= 64 {
//				tetris.physicsBody?.isDynamic = false
//				tetris.physicsBody = nil
//				tetris.removeAllActions()
//			}
//		}
//		_ = children.filter({$0.name == "moving"}).map({$0.name = "structure"})
    }
}
