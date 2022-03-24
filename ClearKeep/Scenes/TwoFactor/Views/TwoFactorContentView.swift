//
//  TwoFactorContentView.swift
//  ClearKeep
//
//  Created by đông on 23/03/2022.
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

struct TwoFactorContentView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var samples: Loadable<[ITwoFactorModel]>
	@State private(set) var security: String
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	let inspection = ViewInspector<Self>()

	// MARK: - Init
	public init(samples: Loadable<[ITwoFactorModel]> = .notRequested,
				security: String = "",
				securityStyle: TextInputStyle = .default,
				keyboardType: UIKeyboardType = .numberPad) {
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
private extension TwoFactorContentView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension TwoFactorContentView {
	var notRequestedView: some View {
		VStack {
			buttonBackView
				.padding(.top, Constant.spacerTopView)
			titleView.padding(.top, Constant.paddingVertical)
			textInputView.padding(.top, Constant.paddingVertical)
			resendCodeTitle.padding(.top, Constant.paddingVertical)
			buttonResend.padding(.bottom, Constant.paddingVertical)
			buttonSocial
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var buttonSocial: some View {
		NavigationLink(
			destination: LoginView(),
			isActive: $isNext,
			label: {
				Button("2FA.Verify".localized) {
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

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundColorWhite)
				Text("2FA.Title.Back".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(foregroundColorWhite)
		}
	}

	var textInputView: some View {
		HStack(spacing: Constant.spacer) {
			PasscodeTextField(text: $security, inputStyle: $securityStyle)
			PasscodeTextField(text: $security, inputStyle: $securityStyle)
			PasscodeTextField(text: $security, inputStyle: $securityStyle)
			PasscodeTextField(text: $security, inputStyle: $securityStyle)
		}
		.frame(maxWidth: .infinity)
	}

	var titleView: some View {
		HStack {
			Text("2FA.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder1))
				.foregroundColor(foregroundMessage)
			Spacer()
		}
	}

	var resendCodeTitle: some View {
		Text("2FA.DontGetCode".localized)
			.font(AppTheme.shared.fontSet.font(style: .placeholder1))
			.foregroundColor(foregroundMessage)
	}

	var buttonResend: some View {
		Button {
			print("Button tapped")
		} label: {
			Text("2FA.Resend".localized)
				.padding(.all)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.frame(maxWidth: .infinity, alignment: .center)
				.foregroundColor(foregroundColorMessage)
		}
	}
}

// MARK: - Private Func
private extension TwoFactorContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
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

struct TwoFactorContentView_Previews: PreviewProvider {
	static var previews: some View {
		TwoFactorContentView()
    }
}
