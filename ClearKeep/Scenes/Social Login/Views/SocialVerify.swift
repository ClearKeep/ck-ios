//
//  SocialThanos.swift
//  ClearKeep
//
//  Created by đông on 09/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerTopView = 50.0
	static let spacerBottomView = 20.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let widthLogo = 160.0
	static let heightLogo = 120.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let paddingHorizontalSignUp = 60.0
	static let widthIconButton = 54.0
	static let heightButton = 40.0
	static let radius = 40.0
	static let heightRectangle = 1.0
	static let lineWidthBorder = 3.0
}

struct SocialVerify: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var samples: Loadable<[ISocialModel]>
	@State private(set) var security: String
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	let inspection = ViewInspector<Self>()

	init(samples: Loadable<[ISocialModel]> = .notRequested,
		security: String = "",
		inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._security = .init(initialValue: security)
		self._securityStyle = .init(initialValue: securityStyle)
	}

	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.background(background)
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension SocialVerify {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension SocialVerify {
	var notRequestedView: some View {
			VStack {
				buttonBack
					.padding(.top, 90)
				titleView.padding(.top, Constant.paddingVertical)
				textInputView.padding(.top, Constant.paddingVertical)
				buttonSocial
				Spacer()
			}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var buttonSocial: some View {
		NavigationLink(
			destination: SocialVerify(),
			isActive: $isNext,
			label: {
				Button("Social.verify.next".localized) {
					isNext = true
				}
				.frame(maxWidth: .infinity)
				.frame(height: Constant.heightButton)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.background(backgroundColorDarkView.opacity(0.4))
				.foregroundColor(foregroundColorView)
				.cornerRadius(Constant.radius)
			})
	}

	var buttonBack: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundColorWhite)
				Text("Social.verify.back".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(foregroundColorWhite)
		}
	}

	var textInputView: some View {
		SecureTextField(secureText: $security,
						inputStyle: $securityStyle,
						inputIcon: AppTheme.shared.imageSet.lockIcon,
						placeHolder: "Social.input.verify".localized,
						keyboardType: .numberPad)
	}

	var titleView: some View {
		HStack {
			Text("Social.title.verify")
				.font(AppTheme.shared.fontSet.font(style: .placeholder1))
				.foregroundColor(foregroundMessage)
			Spacer()
		}
	}
}

// MARK: - Support Variables
private extension SocialVerify {
	var background: LinearGradient {
		colorScheme == .light ? backgroundGradientPrimary : backgroundColorDark
	}

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorWhite: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorDarkView: LinearGradient {
		colorScheme == .light ? backgroundColorWhite : backgroundColorGradient
	}

	var foregroundColorWhite: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundColorView: Color {
		colorScheme == .light ? foregroundColorPrimary : foregroundColorWhite
	}

	var foregroundColorMessage: Color {
		colorScheme == .light ? foregroundColorWhite : foregroundColorPrimary
	}

	var foregroundColorBackground: Color {
		AppTheme.shared.colorSet.background
	}

	var foregroundColorGrey: Color {
		AppTheme.shared.colorSet.grey1
	}

	var foregroundMessage: Color {
		colorScheme == .light ? foregroundColorBackground : foregroundColorGrey
	}
}

// MARK: - Private Func
private extension SocialVerify {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct SocialVerify_Previews: PreviewProvider {
	static var previews: some View {
		SocialVerify()
	}
}
