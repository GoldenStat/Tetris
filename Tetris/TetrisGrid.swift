//
//  TetrisGrid.swift
//  Tetris
//
//  Created by Alexander Völz on 05.08.17.
//  Copyright © 2017 Alexander Völz. All rights reserved.
//

import UIKit
import SpriteKit

class TetrisGrid: SKSpriteNode {
	let rows : CGFloat = 32
	let columns : CGFloat = 20
	var cellWidth : CGFloat!
	var cellHeight : CGFloat!
	
	var dx : CGFloat {
		get { return cellWidth }
	}
	
	var dy : CGFloat {
		get { return cellHeight }
	}
	
	func prepare(for size: CGSize) {
		cellWidth = CGFloat(Int(size.width / columns))
		cellHeight = CGFloat(Int(size.height / rows))
	}
	
	func nearest(point: CGPoint) -> CGPoint {
		// we move the point so it the next closest grid cell in the grid
		let newX = point.x - point.x.truncatingRemainder(dividingBy: cellWidth)
		let newY = point.y - point.y.truncatingRemainder(dividingBy: cellHeight)
		return CGPoint(x: newX, y: newY)
	}
	
	func col(from point: CGPoint) -> Int {
		return Int(point.x / cellWidth)
	}
	
	func row(from point: CGPoint) -> Int {
		return Int(point.y / cellHeight)
	}
}
