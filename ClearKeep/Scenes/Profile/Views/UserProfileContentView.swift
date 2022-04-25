//
//  UserProfileView.swift
//  ClearKeep
//
//  Created by đông on 10/03/2022.
//

import Combine
import Common
import CommonUI
import SwiftUI

private enum Constant {
	static let spacer = 20.0
	static let spacerSetting = 5.0
	static let spacerSettingBottom = 10.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightBackground = 60.0
	static let radius = 16.0
	static let widthButtonPhone = 80.0
	static let heightButtonPhone = 52.0
	static let lineWidth = 2.0
}

struct UserProfileContentView: View {
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@State var countryCode = ""
	@State private(set) var samples: Loadable<[IProfileModel]>
	@State private(set) var username: String
	@State private(set) var usernameStyle: TextInputStyle = .default
	@State private(set) var email: String
	@State private(set) var emailStyle: TextInputStyle = .default
	@State private(set) var phone: String
	@State private(set) var phoneStyle: TextInputStyle = .default
	@State private(set) var isExpand = false
	@State private(set) var isShowCountryCode: Bool = false

	init(samples: Loadable<[IProfileModel]> = .notRequested,
		 username: String = "",
		 email: String = "",
		 phone: String = "",
		 inputStyle: TextInputStyle = .default) {
		_samples = .init(initialValue: samples)
		_username = .init(initialValue: username)
		_usernameStyle = .init(initialValue: inputStyle)
		_email = .init(initialValue: email)
		_emailStyle = .init(initialValue: inputStyle)
		_phone = .init(initialValue: phone)
		_phoneStyle = .init(initialValue: phoneStyle)
	}

	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private

private extension UserProfileContentView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content

private extension UserProfileContentView {
	var notRequestedView: some View {
		VStack {
			backgroundColorTop
				.frame(maxWidth: .infinity, maxHeight: Constant.heightBackground)
			ZStack {
				VStack {
					buttonTop
					profileSettings
						.padding(.top, Constant.spacer)
					textInput
						.padding(.top, Constant.spacer)
					twoFactor
						.padding(.top, Constant.spacer)
					Spacer()
				}
				.padding(.horizontal, Constant.spacer)

				if isShowCountryCode {
					CountryCode(selectedNum: $countryCode, isShowing: $isShowCountryCode)
				}
			}
		}
		.edgesIgnoringSafeArea(.all)
	}

	var buttonTop: some View {
		HStack {
			Button(action: { }, label: {
				AppTheme.shared.imageSet.crossIcon
					.foregroundColor(foregroundCrossButton)
			})
			Spacer()
			Button(action: { }, label: {
				Text("UserProfile.Save".localized)
					.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			})
		}
		.frame(maxWidth: .infinity)
	}

	var profileSettings: some View {
		VStack(alignment: .leading, spacing: Constant.spacer) {
			HStack {
				Text("UserProfile.Setting".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorSetting)
				Spacer()
			}

			Button(action: customBack) {
				HStack {
					Circle()
						.fill(backgroundColorGradient)
						.frame(width: Constant.heightBackground, height: Constant.heightBackground)
					VStack(spacing: Constant.spacerSetting) {
						Text("UserProfile.Picture.Change".localized)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text("UserProfile.Picture.Size".localized)
							.font(AppTheme.shared.fontSet.font(style: .placeholder3))
							.foregroundColor(foregroundColorSetting)
							.padding(.bottom, Constant.spacerSettingBottom)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
			}
		}
		.frame(maxWidth: .infinity)
	}

	var textInput: some View {
		VStack(alignment: .leading, spacing: Constant.spacer) {
			Text("UserProfile.Username".localized)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(AppTheme.shared.colorSet.grey1)

			CommonTextField(text: $username,
							inputStyle: $usernameStyle,
							inputIcon: Image(""),
							placeHolder: "UserProfile.Username".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					usernameStyle = .normal
				} else {
					usernameStyle = .highlighted
				}
			})

			Text("UserProfile.Email".localized)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(AppTheme.shared.colorSet.grey1)

			CommonTextField(text: $email,
							inputStyle: $emailStyle,
							inputIcon: Image(""),
							placeHolder: "UserProfile.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					emailStyle = .normal
				} else {
					emailStyle = .highlighted
				}
			})

			Text("UserProfile.PhoneNumber".localized)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(AppTheme.shared.colorSet.grey1)

			HStack {
				Button("+\(countryCode)") {
					isShowCountryCode = true

				}
				.frame(width: Constant.widthButtonPhone, height: Constant.heightButtonPhone)
				.background(AppTheme.shared.colorSet.grey5)
				.cornerRadius(Constant.radius)
				.overlay(
					RoundedRectangle(cornerRadius: Constant.radius)
						.stroke(AppTheme.shared.colorSet.grey5, lineWidth: Constant.lineWidth)
				)

				CommonTextField(text: $phone,
								inputStyle: $phoneStyle,
								inputIcon: Image(""),
								placeHolder: "UserProfile.PhoneNumber".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					if isEditing {
						phoneStyle = .normal
					} else {
						phoneStyle = .highlighted
					}
				})
			}
			Button(action: buttonSupport) {
				HStack {
					Text("UserProfile.Link.Copy".localized)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(AppTheme.shared.colorSet.primaryDefault)

					Spacer()
					AppTheme.shared.imageSet.copyIcon
						.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
				}
			}

			Button(action: buttonSupport) {
				HStack {
					Text("UserProfile.Password.Change".localized)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(AppTheme.shared.colorSet.primaryDefault)

					Spacer()
					AppTheme.shared.imageSet.arrowRightIcon
						.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
				}
			}
		}
	}

	var twoFactor: some View {
		VStack(spacing: 20) {
			HStack {
				Text("UserProfile.Authen.2FA".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorSetting)

				Spacer()
				Button(action: buttonSupport) {
					Text("UserProfile.Disable".localized)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
				}
			}
			HStack {
				Text("UserProfile.2FA.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .input3))
					.foregroundColor(foregroundColorStatus)
				Spacer()
			}
		}
	}
}

// MARK: - Private Func

private extension UserProfileContentView {
	func customBack() {
		presentationMode.wrappedValue.dismiss()
	}

	func buttonSupport() {
		print("Button pressed")
	}
}

// MARK: - Color func

private extension UserProfileContentView {
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorTop: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var foregroundCrossButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorSetting: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorStatus: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.offWhite
	}
}

struct UserProfileContentView_Previews: PreviewProvider {
	static var previews: some View {
		UserProfileContentView()
	}
}
