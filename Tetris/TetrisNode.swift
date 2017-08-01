//
//  TetrisNode.swift
//  Tetris
//
//  Created by Alexander Völz on 31.07.17.
//  Copyright © 2017 Alexander Völz. All rights reserved.
//

import UIKit
import SpriteKit

class TetrisNode: SKSpriteNode {
	
	let tetrisTypes = [
		[[1,2,3,4,5],[],[]],
		[[1,2,3,4,],[1],[]],
		[[1,2,3,4,],[2],[]],
		[[1,2,3,4,],[3],[]],
		[[1,2,3,4,],[4],[]],
		[[2], [1,2,3],[2]]
	]
	
	let tetrisColors : [UIColor] = [.red, .green, .yellow, .blue, .white, .brown]
	
	var numberOfTypes : Int {
		get { return tetrisTypes.count }
	}
	
	func create(tile ofType: Int) {
		
		let order = tetrisTypes[ofType]
		for (rowindex,row) in order.enumerated() {
			for blockPos in row {
				let block = Block()
				block.prepare()
				block.color = tetrisColors[ofType]
				block.position = CGPoint(x: CGFloat(blockPos) * block.size.width, y: CGFloat(rowindex) * block.size.height)
				addChild(block)
			}
		}
		let blockBodies = children.flatMap {$0.physicsBody}
		physicsBody = SKPhysicsBody(bodies: blockBodies)
		physicsBody?.isDynamic = true
		physicsBody?.restitution = 1.0
		physicsBody?.usesPreciseCollisionDetection = true
		name = "movingTetrisTile"
		let moveDown = SKAction.move(by: CGVector(dx: 0.0, dy: -200.0), duration: 0.5)
		let moveAlwaysDown = SKAction.repeatForever(moveDown)
		run(moveAlwaysDown)
	}
	
}
