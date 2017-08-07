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
	
	func prepare(_ grid: TetrisGrid) {
		
		size = CGSize(width: grid.cellWidth, height: grid.cellHeight)
				
	}
	
}
