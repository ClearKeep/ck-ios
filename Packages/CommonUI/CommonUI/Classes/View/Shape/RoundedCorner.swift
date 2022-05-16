//
//  RoundedCorner.swift
//  CommonUI
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI

public struct RoundedCorner: Shape {
	// MARK: - Variables
	public var radius: CGFloat = .infinity
	public var rectCorner: UIRectCorner
	
	// MARK: - Init
	public init(radius: CGFloat = .infinity, rectCorner: UIRectCorner) {
		self.radius = radius
		self.rectCorner = rectCorner
	}
	
	// MARK: - Draw
	public func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
