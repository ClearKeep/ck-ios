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
	static let spacer = 25.0
	static let paddingVertical = 14.0
}

struct CurrentPasswordView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Binding private(set) var loadable: Loadable<Bool>
	@State private var currentPassword = ""
	@State private(set) var currentPasswordStyle: TextInputStyle = .default
	
	let inspection = ViewInspector<Self>()
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "",
										  titleColor: navBarTitleColor,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				buttonBackView.padding(.top, Constant.spacer)
			},
										  rightBarItems: {
				Spacer()
			})
			.background(background)
			.edgesIgnoringSafeArea(.all)
			.hideKeyboardOnTapped()
	}
}

// MARK: - Private
private extension CurrentPasswordView {
	var content: some View {
		VStack {
			titleView.padding()
			textInputView
			buttonNext.padding(.top, Constant.spacer)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}
}

// MARK: - Loading Content
private extension CurrentPasswordView {
	
	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.frame(width: 25)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(navBarTitleColor)
				Text("CurrentPass.Button.Back".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(navBarTitleColor)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
		}
	}
	
	var buttonNext: some View {
			RoundedButton("CurrentPass.Next".localized,
						  disabled: .constant(disable()),
						  action: doNext)
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
			} else {
				currentPasswordStyle = .normal
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
private extension CurrentPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func doNext() {
		Task {
			loadable = .isLoading(last: nil, cancelBag: CancelBag())
			loadable = await injected.interactors.twoFactorInteractor.validatePassword(password: currentPassword)
		}
	}
	
	func disable() -> Bool {
		return currentPassword.isEmpty
	}
}

// MARK: - Support Variables
private extension CurrentPasswordView {
	var background: LinearGradient {
		colorScheme == .light ? backgroundGradientPrimary : backgroundColorDark
	}
	
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundButtonBack: [Color] {
		colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
	
	var foregroundMessage: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.greyLight
	}
	
	var navBarTitleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}
}
