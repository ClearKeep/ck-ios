//
//  ServerView.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import SwiftUI
private enum Constants {
	static let radius = 40.0
	static let radiusbutton = 4.0
	static let paddingTop = 50.0
	static let paddingTrailling = 100.0
	static let padding = 10.0
	static let sizeImage = 56.0
	static let sizeButton = 22.0
}
struct ServerView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var items: [String] = ["a", "b", "c"]
	@State private(set) var isChangeSever: Bool

	// MARK: - Init
	init(isChangeSever: Bool) {
		self._isChangeSever = .init(initialValue: isChangeSever)
	}
	
	// MARK: - Body
	var body: some View {
		content
			.background(backgroundView.opacity(0.7))
			.mask(CustomShapeLeft(radius: Constants.radius))
			.padding(.top, Constants.paddingTop)
			.padding(.trailing, Constants.paddingTrailling)
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension ServerView {
	var content: AnyView {
		AnyView(severButtonView)
	}
}
// MARK: - Private Func
private extension ServerView {
	var foregroundButtonView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight2
	}
	var backgroundView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryLight : AppTheme.shared.colorSet.darkgrey3
	}
	var backgroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.primaryDark
	}
	func changeServer() {
		self.isChangeSever.toggle()
	}
	func addServer() {

	}
}
// MARK: - Displaying Content
private extension ServerView {
	var severButtonView: some View {
		ScrollView {
			LazyVStack(alignment: .leading) {
				Button(action: changeServer) {
					AppTheme.shared.imageSet.logo
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.sizeButton, height: Constants.sizeButton)
						.foregroundColor(foregroundButtonView)
						.background(backgroundButton)
						.cornerRadius(Constants.radiusbutton)
				}
				.padding(.all, Constants.padding)
				Button(action: addServer) {
					AppTheme.shared.imageSet.plusIcon
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.sizeButton, height: Constants.sizeButton)
						.foregroundColor(foregroundButtonView)
						.background(backgroundButton)
						.cornerRadius(Constants.radiusbutton)
				}
				.padding(.all, Constants.padding)
			}
			.padding(.all, Constants.padding)
			.padding(.top, Constants.paddingTop)
			Spacer()
		}
	}
}
// MARK: - Preview
#if DEBUG
struct ServerView_Previews: PreviewProvider {
	static var previews: some View {
		ServerView(isChangeSever: false)
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
