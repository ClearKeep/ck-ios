//
//  CurrentPassword.swift
//  ClearKeep
//
//  Created by đông on 29/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let heightButton = 40.0
	static let cornerRadius = 40.0
	static let backgroundOpacity = 0.4
}

struct CurrentPassword: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private var currentPassword = ""
	@State private(set) var currentPasswordStyle: TextInputStyle = .default
	@State private(set) var isNextTwoFactor: Bool = false

	let inspection = ViewInspector<Self>()

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "",
										  titleColor: AppTheme.shared.colorSet.offWhite,
										  backgroundColors: AppTheme.shared.colorSet.gradientPrimary,
										  leftBarItems: {
				buttonBackView.padding(.top, Constant.spacerTopView)
			},
										  rightBarItems: {
				Spacer()
			})
			.background(background)
			.edgesIgnoringSafeArea(.all)
			.onDisappear {
				currentPassword = ""
			}
			.hideKeyboardOnTapped()
	}
}

// MARK: - Private
private extension CurrentPassword {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension CurrentPassword {
	var contentView: some View {
		VStack {
			titleView
			textInputView
			buttonNext
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text("CurrentPass.Button.Back".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
		}
	}

	var buttonNext: some View {
		NavigationLink(destination: TwoFactorView(),
					   isActive: $isNextTwoFactor) {
			Button(action: doNext) {
				Text("CurrentPass.Next".localized)
					.frame(maxWidth: .infinity)
					.frame(height: Constant.heightButton)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.background(backgroundButtonNext)
					.foregroundColor(foregroundColorView)
					.cornerRadius(Constant.cornerRadius)
			}
		}
					   .disabled(disable())
	}

	var textInputView: some View {
		SecureTextField(secureText: $currentPassword,
						inputStyle: $currentPasswordStyle,
						inputIcon: AppTheme.shared.imageSet.lockIcon,
						placeHolder: "CurrentPass.Placeholder".localized,
						keyboardType: .default,
						onEditingChanged: { isEditing in
			if isEditing {
				currentPasswordStyle = .highlighted
				print("acb ==== \(currentPassword.isEmpty)")
			} else {
				currentPasswordStyle = .normal
				print("acb ==== \(currentPassword.isEmpty)")
			}
		})
			.padding(.top, Constant.paddingVertical)
	}

	var titleView: some View {
		HStack {
			Text("CurrentPass.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder1))
				.foregroundColor(foregroundMessage)
			Spacer()
		}
		.padding(.top, Constant.paddingVertical)
	}
}

// MARK: - Private Func
private extension CurrentPassword {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func doNext() {
		isNextTwoFactor.toggle()
	}

	func disable() -> Bool {
		return currentPassword.isEmpty
	}
}

// MARK: - Support Variables
private extension CurrentPassword {
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

	var backgroundButtonNext: Color {
		disable() ? backgroundColorButton.opacity(Constant.backgroundOpacity) : backgroundColorButton
	}

	var backgroundColorButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
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

struct CurrentPassword_Previews: PreviewProvider {
	static var previews: some View {
		CurrentPassword()
	}
}
