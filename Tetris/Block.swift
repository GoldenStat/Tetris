//
//  Block.swift
//  Tetris
//
//  Created by Alexander Völz on 31.07.17.
//  Copyright © 2017 Alexander Völz. All rights reserved.
//

import UIKit
import SpriteKit

class Block: SKSpriteNode {
	
	struct const {
		let size : CGFloat = 32.0
	}
	
	func prepare() {
		
		size = CGSize(width: const().size, height: const().size)
		
		physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: const().size, height: const().size))
		physicsBody?.allowsRotation = false
		physicsBody?.affectedByGravity = false
		physicsBody?.isDynamic = false
		physicsBody?.pinned = true 
		
	}
	
}
