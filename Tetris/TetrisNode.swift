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
	
	let matrixDimension = 5 // all pieces are set in a 5x5 Matrix
	let offsetAdjustment = 2 // horizontal adjustment
	
	let tetrisTypes = [
		[[],[1,2,3,4,5],[]],
		[[1,2,3,4],[1],[]],
		[[1,2,3,4],[2],[]],
		[[1,2,3,4],[3],[]],
		[[1,2,3,4],[4],[]],
		[[2],[1,2,3],[2]],
//		[[1]],[[2]],[[3]],[[4]]
	]
	
	let tetrisColors : [UIColor] = [.red, .green, .yellow, .blue, .white, .brown]
	
	var numberOfTypes : Int {
		get { return tetrisTypes.count }
	}
	
	func rotatedPosition(for block: Block, in grid: TetrisGrid) -> CGPoint {
		// rotated coordinates of pos i,j are j,n-i
		let i = grid.row(from: block.position)
		let j = grid.col(from: block.position)
		
		let iNew = j
		let jNew = matrixDimension - offsetAdjustment - i
		
		let xRotated = CGFloat(iNew) * grid.cellWidth
		let yRotated = CGFloat(jNew) * grid.cellHeight
		
		print("rotation: (\(i),\(j)) -> (\(iNew),\(jNew))")
		
		return CGPoint(x: xRotated, y: yRotated)
		
	}
	
	func create(tile ofType: Int, for grid: TetrisGrid) {
		
		let order = tetrisTypes[ofType]
		for (rowindex,row) in order.enumerated() {
			for blockPos in row {
				let block = Block()
				block.prepare(grid)
				block.name = String("(\(rowindex):\(blockPos))")
				block.color = tetrisColors[ofType]
				block.position = CGPoint(x: CGFloat(blockPos - offsetAdjustment) * grid.cellWidth, y: CGFloat(rowindex-1) * grid.cellHeight)
				addChild(block)
			}
		}
		
	}
	
}
