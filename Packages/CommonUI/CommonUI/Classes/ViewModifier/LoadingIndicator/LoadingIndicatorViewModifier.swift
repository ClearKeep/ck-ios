//
//  LoadingIndicatorViewModifier.swift
//  CommonUI
//
//  Created by NamNH on 26/04/2022.
//

import SwiftUI

private enum Constants {
	static let containerSize: CGSize = CGSize(width: 100.0, height: 100.0)
	static let cornerRadius: CGFloat = 20.0
	static let blurRadius: CGFloat = 3.0
}

public struct LoadingIndicatorViewModifier: ViewModifier {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	private let scaleSize: CGFloat
	
	// MARK: - Init
	public init(scaleSize: CGFloat = 2.0) {
		self.scaleSize = scaleSize
	}
	
	// MARK: - Body
	public func body(content: Content) -> some View {
		ZStack(alignment: .center) {
			content
				.disabled(true)
				.blur(radius: Constants.blurRadius)
			
			ProgressView()
				.scaleEffect(scaleSize, anchor: .center)
				.progressViewStyle(CircularProgressViewStyle(tint: tintColor))
				.frame(width: Constants.containerSize.width,
					   height: Constants.containerSize.height)
				.background(Color.secondary.colorInvert())
				.foregroundColor(Color.primary)
				.cornerRadius(Constants.cornerRadius)
		}
	}
}

// MARK: - Private func
private extension LoadingIndicatorViewModifier {
}

// MARK: - Support Variables
private extension LoadingIndicatorViewModifier {
	var tintColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.lightLoading : commonUIConfig.colorSet.darkLoading
	}
}
