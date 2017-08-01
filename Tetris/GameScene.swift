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
	
	func didBegin(_ contact: SKPhysicsContact) {
		if let tetrisTile = contact.bodyA.node as? TetrisNode {
			collision(tetrisTile: tetrisTile, object: contact.bodyB.node!)
		}
		else {
			collision(tetrisTile: contact.bodyB.node as! TetrisNode, object: contact.bodyA.node!)
		}
		
	}
	
	fileprivate func deleteTetrisTile(_ tetrisTile: TetrisNode) {
		let blocks = tetrisTile.children
		for block in blocks {
			block.move(toParent: self)
		}
		
		tetrisTile.removeFromParent()
	}
	
	func collision(tetrisTile: TetrisNode, object: SKNode) {
		deleteTetrisTile(tetrisTile)
		if let tile = object as? TetrisNode {
			deleteTetrisTile(tile)
		}
		createTetris()
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
