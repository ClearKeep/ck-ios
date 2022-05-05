//
//  SocialView.swift
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

struct SocialView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var samples: Loadable<[ISocialModel]> = .notRequested
	@State private(set) var security: String = ""
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	var socialStyle: SocialCommonStyle
	
	let inspection = ViewInspector<Self>()
	
	// MARK: - Init
	init(socialStyle: SocialCommonStyle) {
		self.socialStyle = socialStyle
	}
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.applyNavigationBarPlainStyle(title: buttonBack.localized,
										  titleColor: AppTheme.shared.colorSet.black,
										  backgroundColors: AppTheme.shared.colorSet.gradientPrimary,
										  leftBarItems: {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
			},
										  rightBarItems: {
				Spacer()
			})
			.background(background)
		
	}
}

// MARK: - Private
private extension SocialView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension SocialView {
	var notRequestedView: some View {
		VStack {
			titleView
			textInputView
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
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text(buttonBack.localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
		}
	}
	
	var textInputView: some View {
		SecureTextField(secureText: $security,
						inputStyle: $securityStyle,
						inputIcon: AppTheme.shared.imageSet.lockIcon,
						placeHolder: textInput.localized,
						keyboardType: .numberPad,
						onEditingChanged: { isEditing in
			if isEditing {
				securityStyle = .highlighted
			} else {
				securityStyle = .normal
			}
		})
			.padding(.top, Constant.paddingVertical)
	}
	
	var titleView: some View {
		HStack {
			Text(title.localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder1))
				.foregroundColor(foregroundMessage)
			Spacer()
		}
		.padding(.top, Constant.paddingVertical)
	}
}

// MARK: - Support Variables
private extension SocialView {
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
	
	var foregroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorMessage: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}
	
	var foregroundMessage: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.grey1
	}
}

// MARK: - Private Func
private extension SocialView {
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

struct SocialView_Previews: PreviewProvider {
	static var previews: some View {
		SocialView(socialStyle: .confirmSecurity)
	}
}
