//
//  TwoFactorContentView.swift
//  ClearKeep
//
//  Created by đông on 17/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerResend = 10.0
	static let spacerTopView = 90.0
	static let spacer = 20.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightButton = 40.0
	static let cornerRadius = 40.0
}

struct TwoFactorContentView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var samples: Loadable<[ITwoFactorModel]>
	@State private(set) var passcode: String
	@State private(set) var passcodeStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	let inspection = ViewInspector<Self>()

	init(samples: Loadable<[ITwoFactorModel]> = .notRequested,
		 passcode: String = "",
		inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._passcode = .init(initialValue: passcode)
		self._passcodeStyle = .init(initialValue: passcodeStyle)
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
private extension TwoFactorContentView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension TwoFactorContentView {
	var notRequestedView: some View {
		VStack(spacing: Constant.spacer) {
				buttonBack
				.padding(.top, Constant.spacerTopView)
				titleView.padding(.top, Constant.paddingVertical)
				textInputView.padding(.top, Constant.paddingVertical)
				resendCode
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
				Button("2fa.Verify".localized) {
					isNext = true
				}
				.frame(maxWidth: .infinity)
				.frame(height: Constant.heightButton)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.background(backgroundColorView)
				.foregroundColor(foregroundColorView)
				.cornerRadius(Constant.cornerRadius)
			})
	}

	var buttonBack: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundColorWhite)
				Text("2fa.BackButton".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(foregroundColorWhite)
		}
	}

	var textInputView: some View {
		HStack(spacing: 20) {
			PasscodeTextField(text: $passcode,
						  inputStyle: $passcodeStyle)
			PasscodeTextField(text: $passcode,
						  inputStyle: $passcodeStyle)
			PasscodeTextField(text: $passcode,
						  inputStyle: $passcodeStyle)
			PasscodeTextField(text: $passcode,
						  inputStyle: $passcodeStyle)
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, Constant.cornerRadius)

	}

	var titleView: some View {
		HStack {
			Text("2fa.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder1))
				.foregroundColor(foregroundMessage)
			Spacer()
		}
	}

	var resendCode: some View {
		VStack(alignment: .center, spacing: Constant.spacerResend) {
			Text("2fa.DontGetCode".localized)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(foregroundColorWhite)
			Text("2fa.ResendCode".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundColorMessage)
		}
	}
}

// MARK: - Support Variables
private extension TwoFactorContentView {
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

	var backgroundColorView: LinearGradient {
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
		colorScheme == .light ? foregroundColorBackground : foregroundColorWhite
	}
}

// MARK: - Private Func
private extension TwoFactorContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct TwoFactorContentView_Previews: PreviewProvider {
	static var previews: some View {
		TwoFactorContentView()
	}
}
