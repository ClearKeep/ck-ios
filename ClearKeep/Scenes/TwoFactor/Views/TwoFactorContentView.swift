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
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let cornerRadius = 40.0
	static let cornerRadiusPasscode = 8.0
	static let sizePasscodeInput = 90.0
	static let maxDigits = 4
}

struct TwoFactorContentView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Binding private(set) var loadable: Loadable<Bool>
	@State private var otp: String = ""
	@State private var otpStyle: TextInputStyle = .default
	@State private var isToHome: Bool = false
	private(set) var otpHash: String = ""
	private(set) var userId: String = ""
	private(set) var domain: String = ""
	private(set) var password: String = ""
	let twoFactorType: TwoFactorType
	let inspection = ViewInspector<Self>()

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "",
										  titleColor: AppTheme.shared.colorSet.offWhite,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				buttonBackView
			},
										  rightBarItems: {
				Spacer()
			})
			.background(background)
			.edgesIgnoringSafeArea(.all)
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
			titleView.padding(.top, Constant.paddingVertical)
			ZStack {
				pinDots
				backgroundField
			}
			resendCodeTitle.padding(.top, Constant.paddingVertical)
			buttonResend.padding(.bottom, Constant.paddingVertical)
			buttonVerify
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var buttonVerify: some View {
		RoundedButton("2FA.Verify".localized,
					  disabled: .constant(otp.count < Constant.maxDigits),
					  action: doTwoFactor)
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(navBarTitleColor)
				Text("2FA.Title.Back".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(navBarTitleColor)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
		}
	}

	var pinDots: some View {
		HStack {
			ForEach(0..<Constant.maxDigits, id: \.self) { index in
				ZStack {
					Spacer()
					RoundedRectangle(cornerRadius: Constant.cornerRadiusPasscode)
						.foregroundColor(pinInputColor)
						.padding()
						.frame(width: Constant.sizePasscodeInput, height: Constant.sizePasscodeInput)
					Text(self.getDigits(at: index))
						.font(AppTheme.shared.fontSet.font(style: .heading3))
						.foregroundColor(AppTheme.shared.colorSet.black)
					Spacer()
				}
			}
			.frame(minWidth: 0, maxWidth: .infinity)
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var backgroundField: some View {
		return TextField("", text: $otp)
			.onChange(of: self.otp, perform: { value in
				self.otp = String(value.prefix(Constant.maxDigits))
			})
			.accentColor(.clear)
			.foregroundColor(.clear)
			.keyboardType(.numberPad)
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
			doResendOTP()
		} label: {
			Text("2FA.Resend".localized)
				.padding(.all, 1)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundColorMessage)
		}
	}
}

// MARK: - Private Func
private extension TwoFactorContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	private func getDigits(at index: Int) -> String {
		if index >= self.otp.count {
			return ""
		}
		return self.otp.digits[index].numberString
	}

	func doTwoFactor() {
		Task {
			if twoFactorType == .login {
				await injected.interactors.twoFactorInteractor.validateLoginOTP(loadable: $loadable, password: password, otp: otp, userId: userId, otpHash: otpHash, domain: domain)
			} else {
				let result = await injected.interactors.twoFactorInteractor.validateOTP(loadable: $loadable, otp: otp)
				if result {
					DispatchQueue.main.async {
						self.presentationMode.wrappedValue.dismiss()
					}
				}
			}
		}
	}
	
	func doResendOTP() {
		Task {
			if twoFactorType == .login {
				await injected.interactors.twoFactorInteractor.resendLoginOTP(loadable: $loadable, userId: userId, otpHash: otpHash, domain: domain)
			} else {
				await injected.interactors.twoFactorInteractor.resendOTP(loadable: $loadable)
			}
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

	var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var foregroundColorMessage: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundMessage: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.greyLight
	}
	
	var navBarTitleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}
	
	var pinInputColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight2
	}
}

private extension String {
	var digits: [Int] {
		var result = [Int]()
		for char in self {
			if let number = Int(String(char)) {
				result.append(number)
			}
		}
		return result
	}
}

private extension Int {
	var numberString: String {
		guard self < 10 else { return "0" }
		return String(self)
	}
}

private extension View {
	func limitInputLength(value: Binding<String>, length: Int) -> some View {
		self.modifier(TextFieldLimitModifer(value: value, length: length))
	}
}

struct TextFieldLimitModifer: ViewModifier {
	@Binding var value: String
	var length: Int

	func body(content: Content) -> some View {
		content
			.onReceive(value.publisher.collect()) {
				value = String($0.prefix(length))
			}
	}
}
