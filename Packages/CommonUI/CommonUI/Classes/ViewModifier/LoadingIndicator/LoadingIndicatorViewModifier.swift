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

struct LoadingIndicatorViewModifier: ViewModifier {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	private let isLoading: Bool
	private let scaleSize: CGFloat
	
	// MARK: - Init
	public init(isLoading: Bool, scaleSize: CGFloat = 2.0) {
		self.isLoading = isLoading
		self.scaleSize = scaleSize
	}
	
	// MARK: - Body
	func body(content: Content) -> some View {
		ZStack(alignment: .center) {
			content
				.disabled(isLoading)
				.if(isLoading) { view in
					view.blur(radius: Constants.blurRadius)
				}
			
			if isLoading {
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

extension View {
	public func progressHUD(_ isLoading: Bool) -> some View {
		self.modifier(LoadingIndicatorViewModifier(isLoading: isLoading))
	}
}
