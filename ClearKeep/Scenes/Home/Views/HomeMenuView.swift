//
//  HomeMenuView.swift
//  ClearKeep
//
//  Created by MinhDev on 11/03/2022.
//

import SwiftUI

private enum Constants {
	static let radius = 40.0
	static let spacing = 10.0
	static let paddingTop = 50.0
	static let paddingLeading = 100.0
	static let padding = 20.0
	static let sizeImage = 56.0
	static let sizeCircle = 12.0
	static let sizeOffset = 30.0
	static let expandWidth = 15.0
	static let expandHeight = 10.0
	static let sizeIcon = 24.0
	static let sizeDisable = 24.0
}
struct HomeMenuView: View {
	// MARK: - Constants
	
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var userName: String
	@State private(set) var urlString: String
	@State private(set) var expand: Bool
	@State private(set) var show: Bool
	@State private(set) var isChangeStatus: Bool = true
	@Binding var isMenuAction: Bool

	// MARK: - body
	var body: some View {
		content
			.background(backgroundColorView.opacity(0.9))
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension HomeMenuView {
	var content: AnyView {
		AnyView(menuView)
	}
	var list: AnyView {
		AnyView(listView)
	}
	var status: AnyView {
		AnyView(statusView)
	}
	var popUp: AnyView {
		AnyView(popUpView)
	}
	var profile: AnyView {
		AnyView(profileView)
	}
}
// MARK: - Private variable
private extension HomeMenuView {
	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}
	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	var backgroundColorMenu: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
	var foregroundStatusView: Color {
		isChangeStatus ? AppTheme.shared.colorSet.successDefault : AppTheme.shared.colorSet.errorDefault
	}
	var foregroundButtonExpand: Color {
		isChangeStatus ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.grey5
	}
	var foregroundColorUserName: Color {
		AppTheme.shared.colorSet.primaryDefault
	}
	var foregroundColorUrlString: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.grey1
	}
	var foregroundButtonCoppy: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDark : AppTheme.shared.colorSet.primaryDefault
	}
	var foregroundText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.grey5
	}
}
// MARK: - Private func
private extension HomeMenuView {
	func statusAction() {
		isChangeStatus.toggle()
	}
	func expandAction() {
		expand.toggle()
	}
	func copyAction() {

	}
	func menuAction() {
		isMenuAction.toggle()
	}
	func signOut() {

	}
}
// MARK: - Displaying Content
private extension HomeMenuView {

	var menuView: some View {
		VStack(alignment: .trailing) {
			Button(action: menuAction) {
				AppTheme.shared.imageSet.crossIcon
					.resizable()
					.frame(width: Constants.sizeDisable, height: Constants.sizeDisable)
			}
			.padding(.top, Constants.padding)
			.padding(.trailing, Constants.padding)
			profile
			Divider()
			list
				.padding(.trailing, Constants.padding)
				.padding(.top, Constants.padding)
			Spacer()
			Button(action: signOut) {
				HStack {
					Spacer()
					AppTheme.shared.imageSet.logoutIcon
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
					.padding(.all, Constants.padding)
					Text("Home.Signout".localized)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(AppTheme.shared.colorSet.errorDefault)
					Spacer()
				}
			}
		}
		.background(backgroundColorMenu)
		.mask(CustomShapeRight(radius: Constants.radius))
		.padding(.top, Constants.paddingTop)
		.padding(.bottom, Constants.paddingTop)
		.padding(.leading, Constants.paddingLeading)
		.edgesIgnoringSafeArea(.all)
	}
	var profileView: some View {
		HStack {
			ZStack {
				AppTheme.shared.imageSet.facebookIcon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
					.padding(.leading, Constants.padding)
					.padding(.bottom, Constants.padding)
				Circle()
					.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
					.offset(x: Constants.sizeOffset, y: -Constants.sizeOffset)
					.foregroundColor(foregroundStatusView)
			}
			status
				.padding()
		}
	}
	var statusView: some View {
		ZStack {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				Text(userName)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorUserName)
				popUp
				HStack {
					Text(urlString)
						.font(AppTheme.shared.fontSet.font(style: .placeholder3))
						.foregroundColor(foregroundColorUrlString)
					Spacer()
					Button(action: copyAction) {
						AppTheme.shared.imageSet.copyIcon
							.foregroundColor(foregroundButtonCoppy)
					}
				}
			}
		}
	}
	var popUpView: some View {
		Button(action: expandAction) {
			HStack {
				Text("online")
					.font(AppTheme.shared.fontSet.font(style: .input3))
					.foregroundColor(foregroundStatusView)
				AppTheme.shared.imageSet.chevDownIcon
					.resizable()
					.frame(width: Constants.expandWidth, height: Constants.expandHeight)
					.foregroundColor(foregroundButtonExpand)
			}
		}
	}
	var listView: some View {
		Button(action: expandAction) {
			HStack {
				AppTheme.shared.imageSet.userIcon
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
					.padding(.all, Constants.padding)
				Text("Home.Profile".localized)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundText)
				Spacer()
			}
		}
	}
}
// MARK: - Preview
#if DEBUG
struct HomeMenuView_Previews: PreviewProvider {
	static var previews: some View {
		HomeMenuView(userName: "Test", urlString: "test", expand: false, show: true, isChangeStatus: true, isMenuAction: .constant(false))
	}
}
#endif

struct CustomShapeRight: Shape {
	let radius: CGFloat
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let trailingRight = CGPoint(x: rect.maxX, y: rect.minY)
		let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
		let bottomLeftStrart = CGPoint(x: rect.minX + radius, y: rect.maxY)
		let bottomLeftEnd = CGPoint(x: rect.minX + radius, y: rect.maxY - radius)
		let trailingLeftStart = CGPoint(x: rect.minX, y: rect.minY + radius )
		let trailingLeftEnd = CGPoint(x: rect.minX + radius, y: rect.minY + radius)
		// Do stuff here to draw the outline of the mask
		path.move(to: trailingRight)
		path.addLine(to: bottomRight)
		path.addLine(to: bottomLeftStrart)
		path.addRelativeArc(center: bottomLeftEnd, radius: radius, startAngle: Angle.degrees(90), delta: Angle.degrees(90))
		path.addLine(to: trailingLeftStart)
		path.addRelativeArc(center: trailingLeftEnd, radius: radius, startAngle: Angle.degrees(90), delta: Angle.degrees(180))
		path.addLine(to: trailingRight)
		return path
	}
}
