//
//  BubbleArrow.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI

struct BubbleArrow: Shape {
	// MARK: - Variables
	var rectCorner: UIRectCorner
	
	// MARK: - Draw
	func path(in rect: CGRect) -> Path {
		return RoundedCorner(radius: 32.0, rectCorner: rectCorner).path(in: rect)
	}
}

struct QuoteBubbleArrow: Shape {
	// MARK: - Variables
	var rectCorner: UIRectCorner
	
	// MARK: - Draw
	func path(in rect: CGRect) -> Path {
		return RoundedCorner(radius: 16.0, rectCorner: rectCorner).path(in: rect)
	}
}
