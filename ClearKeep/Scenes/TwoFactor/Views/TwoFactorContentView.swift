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
	static let heightButton = 40.0
	static let cornerRadius = 40.0
	static let cornerRadiusPasscode = 8.0
	static let sizePasscodeInput = 90.0
	static let backgroundOpacity = 0.4
}

struct TwoFactorContentView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private var otp: String = ""
	@State private var otpStyle: TextInputStyle = .default
	@State private var isNext: Bool = false
	@State private var maxDigits: Int = 4
	@State private var showOtp = true
	@State private var userId: String = ""
	@State private var otpHash: String = ""
	@State private var hashKey: String = ""
	@State private var domain: String = ""
	let inspection = ViewInspector<Self>()

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
		NavigationLink(
			destination: LoginView(),
			isActive: $isNext) {
				Button {
					isNext.toggle()
					doTwoFactor()
				} label: {
					Text("2FA.Verify".localized)
						.frame(maxWidth: .infinity)
						.frame(height: Constant.heightButton)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.background(backgroundButton)
						.foregroundColor(foregroundColorView)
						.cornerRadius(Constant.cornerRadius)
				}
			}
			.disabled(otp.count < maxDigits)
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
				Text("2FA.Title.Back".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
		}
	}

	var pinDots: some View {
		HStack {
			ForEach(0..<maxDigits) { index in
				ZStack {
					Spacer()
					RoundedRectangle(cornerRadius: Constant.cornerRadiusPasscode)
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
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
				self.otp = String(value.prefix(maxDigits))
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

	private func getDigits(at index: Int) -> String {
		if index >= self.otp.count {
			return ""
		}
		return self.otp.digits[index].numberString
	}

	func doTwoFactor() {
		Task {
			await injected.interactors.twoFactorInteractor.validateOTP(userId: userId, otp: otp, otpHash: otpHash, haskKey: hashKey, domain: domain)
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

	var backgroundButton: Color {
		return otp.count < maxDigits ? backgroundColorButton.opacity(Constant.backgroundOpacity) : backgroundColorButton
	}

	var backgroundColorButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorMessage: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundMessage: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.offWhite
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

struct TwoFactorContentView_Previews: PreviewProvider {
	static var previews: some View {
		TwoFactorContentView()
	}
}
