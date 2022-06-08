//
//  AvatarDefault.swift
//  _NIODataStructures
//
//  Created by MinhDev on 07/06/2022.
//

import SwiftUI

private enum Constants {
	static let imageSize = CGSize(width: 60.0, height: 60.0)
	static let textSize = CGSize(width: 14.0, height: 32.0)
}

public struct AvatarDefault: View {
	// MARK: - Variables
	private var title: String
	
	// MARK: - Init
	public init(title: String) {
		self.title = title
	}

	// MARK: - Body
	public var body: some View {
		ZStack {
			Circle()
				.fill(backgroundColor)
				.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
			Text(title)
				.foregroundColor(commonUIConfig.colorSet.offWhite)
				.font(commonUIConfig.fontSet.font(style: .display3))
		}
	}
}

private extension AvatarDefault {
	var backgroundColor: LinearGradient {
		LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}
