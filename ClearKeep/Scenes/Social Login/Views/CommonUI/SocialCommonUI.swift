//
//  SocialCommonUI.swift
//  ClearKeep
//
//  Created by đông on 18/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerTopView = 90.0
	static let spacerBottomView = 20.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let paddingHorizontalSignUp = 60.0
	static let heightButton = 40.0
	static let cornerRadius = 40.0
	static let backgroundOpacity = 0.4
}

struct SocialCommonUI: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Binding var text: String
	@Binding var socialStyle: SocialCommonStyle
	@State private(set) var samples: Loadable<[ISocialModel]>
	@State private(set) var security: String
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	let inspection = ViewInspector<Self>()

	// MARK: - Init
	public init(samples: Loadable<[ISocialModel]> = .notRequested,
				security: String = "",
				text: Binding<String>,
				socialStyle: Binding<SocialCommonStyle>,
				inputStyle: TextInputStyle = .default) {
		self._text = text
		self._socialStyle = socialStyle
		self._samples = .init(initialValue: samples)
		self._security = .init(initialValue: security)
	}

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.background(background)
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension SocialCommonUI {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension SocialCommonUI {
	var notRequestedView: some View {
		VStack {
			buttonBackView
				.padding(.top, Constant.spacerTopView)
			titleView.padding(.top, Constant.paddingVertical)
			textInputView.padding(.top, Constant.paddingVertical)
			buttonSocial
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var buttonSocial: some View {
		NavigationLink(
			destination: nextView,
			isActive: $isNext,
			label: {
				Button(buttonNext.localized) {
					isNext = true
				}
				.frame(maxWidth: .infinity)
				.frame(height: Constant.heightButton)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.background(backgroundColorDarkView.opacity(Constant.backgroundOpacity))
				.foregroundColor(foregroundColorView)
				.cornerRadius(Constant.cornerRadius)
			})
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text(buttonBack.localized)
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
						placeHolder: textInput.localized,
						keyboardType: .numberPad)
	}

	var titleView: some View {
		HStack {
			Text(title.localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder1))
				.foregroundColor(foregroundMessage)
			Spacer()
		}
	}
}

// MARK: - Support Variables
private extension SocialCommonUI {
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
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundColorView: Color {
		colorScheme == .light ? foregroundColorPrimary : foregroundColorWhite
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? foregroundColorWhite : foregroundColorGreyLight
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

	var foregroundColorGreyLight: Color {
		AppTheme.shared.colorSet.greyLight
	}

	var foregroundMessage: Color {
		colorScheme == .light ? foregroundColorBackground : foregroundColorGrey
	}
}

// MARK: - Private Func
private extension SocialCommonUI {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	var title: String {
		socialStyle.title
	}

	var textInput: String {
		socialStyle.textInput
	}

	var buttonBack: String {
		socialStyle.buttonBack
	}

	var buttonNext: String {
		socialStyle.buttonNext
	}

	var nextView: some View {
		socialStyle.nextView
	}
}

struct SocialCommonUI_Previews: PreviewProvider {
	static var previews: some View {
		SocialCommonUI(text: .constant("Test"), socialStyle: .constant(.setSecurity))
	}
}
