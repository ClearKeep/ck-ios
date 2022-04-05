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
	static let cornerRadiusPasscode = 8.0
	static let paddingTrailing = -24.0
	static let sizePasscodeInput = 90.0
}

struct TwoFactorContentView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var samples: Loadable<[ITwoFactorModel]>
	@State private(set) var pin: String
	@State var showPin = true
	@State private(set) var pinStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	@State private(set) var maxDigits: Int
	let inspection = ViewInspector<Self>()

	// MARK: - Init
	public init(samples: Loadable<[ITwoFactorModel]> = .notRequested,
				pin: String = "",
				maxDigits: Int = 4,
				pinStyle: TextInputStyle = .default,
				keyboardType: UIKeyboardType = .numberPad) {
		self._samples = .init(initialValue: samples)
		self._pin = .init(initialValue: pin)
		self._maxDigits = .init(initialValue: maxDigits)
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
			ZStack {
				pinDots
				backgroundField
			}
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

	var pinDots: some View {
		HStack {
			ForEach(0..<maxDigits) { index in
				ZStack {
					Spacer()
					RoundedRectangle(cornerRadius: Constant.cornerRadiusPasscode)
						.foregroundColor(foregroundColorWhite)
						.padding()
						.frame(width: Constant.sizePasscodeInput, height: Constant.sizePasscodeInput)
					Text(self.getDigits(at: index))
						.font(AppTheme.shared.fontSet.font(style: .heading3))
						.foregroundColor(foregroundColorBlack)
					Spacer()
				}
			}
			.frame(minWidth: 0, maxWidth: .infinity)
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var backgroundField: some View {
		return TextField("", text: $pin)
			.onChange(of: self.pin, perform: { value in
				self.pin = String(value.prefix(maxDigits))
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
		if index >= self.pin.count {
			return ""
		}
		return self.pin.digits[index].numberString
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

	var foregroundColorBlack: Color {
		AppTheme.shared.colorSet.black
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

	var foregroundColorGrey1: Color {
		AppTheme.shared.colorSet.grey1
	}

	var foregroundColorGreyLight: Color {
		AppTheme.shared.colorSet.greyLight
	}

	var foregroundMessage: Color {
		colorScheme == .light ? foregroundColorBackground : foregroundColorWhite
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
