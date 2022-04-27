//
//  ServerView.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import SwiftUI
private enum Constants {
	static let radius = 30.0
	static let paddingTop = 50.0
	static let paddingTrailling = 100.0
	static let padding = 15.0
	
}

struct ServerView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		LazyVStack(alignment: .center) {
			ButtonServerView()
			Spacer()
		}
		.frame(maxHeight: .infinity)
		.background(backgroundColorView.opacity(0.3))
		.mask(CustomShapeLeft(radius: Constants.radius))
		.padding(.top, Constants.paddingTop)
		.padding(.trailing, Constants.paddingTrailling)
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension ServerView {
	var foregroundButtonView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight2
	}
	
	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorLight : backgroundColorDark
	}
	
	var backgroundColorLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientSecondary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.grey2, AppTheme.shared.colorSet.grey2]), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Private func
private extension ServerView {
	
}

// MARK: - Preview
#if DEBUG
struct ServerView_Previews: PreviewProvider {
	static var previews: some View {
		ServerView()
	}
}
#endif

struct CustomShapeLeft: Shape {
	let radius: CGFloat
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let bottomleft = CGPoint(x: rect.minX, y: rect.maxY)
		let trailingLeft = CGPoint(x: rect.minX, y: rect.minY)
		let trailingLeftStart = CGPoint(x: rect.minX + radius, y: rect.minY )
		let trailingLeftEnd = CGPoint(x: rect.minX + radius, y: rect.minY + radius)
		let bottomRight = CGPoint(x: rect.minX + radius, y: rect.maxY )
		// Do stuff here to draw the outline of the mask
		path.move(to: bottomleft)
		path.addLine(to: trailingLeft)
		path.addLine(to: trailingLeftStart)
		path.addRelativeArc(center: trailingLeftEnd, radius: radius, startAngle: Angle.degrees(-90), delta: Angle.degrees(90))
		path.addRelativeArc(center: bottomRight, radius: radius, startAngle: Angle.degrees(0), delta: Angle.degrees(90))
		path.addLine(to: bottomleft)
		return path
	}
}
