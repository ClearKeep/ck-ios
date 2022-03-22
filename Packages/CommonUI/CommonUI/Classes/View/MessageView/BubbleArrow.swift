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
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: 32, height: 32))
		return Path(path.cgPath)
	}
}
