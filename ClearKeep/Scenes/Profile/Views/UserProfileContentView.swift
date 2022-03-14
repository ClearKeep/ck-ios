//
//  UserProfileView.swift
//  ClearKeep
//
//  Created by đông on 10/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

struct UserProfileContentView: View {
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IProfileModel]>
	@State private(set) var username: String
	@State private(set) var usernameStyle: TextInputStyle = .default
	@State private(set) var email: String
	@State private(set) var emailStyle: TextInputStyle = .default
	@State private(set) var phone: String
	@State private(set) var phoneStyle: TextInputStyle = .default
	@State private(set) var isExpand = false
	@State private(set) var selectedNum = 1

	init(samples: Loadable<[IProfileModel]> = .notRequested,
		 username: String = "",
		 email: String = "",
		 phone: String = "",
		 inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._username = .init(initialValue: username)
		self._usernameStyle = .init(initialValue: inputStyle)
		self._email = .init(initialValue: email)
		self._emailStyle = .init(initialValue: inputStyle)
		self._phone = .init(initialValue: phone)
		self._phoneStyle = .init(initialValue: phoneStyle)
	}
	
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
		//			.background(background)
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
			buttonTop
			profileSettings
				.padding(.top, 20)
			textInput
				.padding(.top, 20)
			twoFactor
				.padding(.top, 20)
			Spacer()
		}
		.padding(.horizontal, 20)
	}

	var buttonTop: some View {
		HStack {
			Button(action: { }, label: {
				AppTheme.shared.imageSet.crossIcon
			})
			Spacer()
			Button(action: { }, label: {
				Text("UserProfile.save")
					.foregroundColor(foregroundPrimary)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			})
		}
		.frame(maxWidth: .infinity)
	}

	var profileSettings: some View {
		VStack(alignment: .leading, spacing: 20.0) {
			HStack {
				Text("UserProfile.setting".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorSetting)
				Spacer()
			}

			Button(action: customBack) {
				HStack {
					Circle()
						.fill(backgroundColorGradient)
						.frame(width: 60, height: 60)
					VStack {
						Text("UserProfile.picture.change".localized)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(foregroundPrimary)
						Text("UserProfile.picture.size".localized)
							.font(AppTheme.shared.fontSet.font(style: .placeholder3))
							.foregroundColor(foregroundColorSetting)
							.padding(.bottom, 10)
					}
				}
			}
		}
		.frame(maxWidth: .infinity)
	}

	var textInput: some View {
		VStack(alignment: .leading, spacing: 20.0) {
			Text("UserProfile.username".localized)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(foregroundGrey1)

			CommonTextField(text: $username,
							inputStyle: $usernameStyle,
							inputIcon: Image(""),
							placeHolder: "UserProfile.username".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					usernameStyle = .normal
				} else {
					usernameStyle = .highlighted
				}
			})

			Text("UserProfile.email".localized)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(foregroundGrey1)

			CommonTextField(text: $email,
							inputStyle: $emailStyle,
							inputIcon: Image(""),
							placeHolder: "UserProfile.email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					emailStyle = .normal
				} else {
					emailStyle = .highlighted
				}
			})

			Text("UserProfile.phoneNumber".localized)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(foregroundGrey1)
			
			HStack {
				DisclosureGroup("+\(selectedNum)", isExpanded: $isExpand) {
					VStack(alignment: .leading) {
						ForEach(1...5, id: \.self) { num in
							Text("+\(num)")
								.onTapGesture {
									self.selectedNum = num
									withAnimation {
										self.isExpand.toggle()
									}
								}
						}
					}
				}
				.frame(width: 80, height: 52)
				.background(AppTheme.shared.colorSet.grey5)
				.cornerRadius(16)
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.stroke(AppTheme.shared.colorSet.grey5, lineWidth: 2)
				)

				CommonTextField(text: $phone,
								inputStyle: $phoneStyle,
								inputIcon: Image(""),
								placeHolder: "UserProfile.phoneNumber".localized,
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
					Text("UserProfile.link.copy".localized)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(foregroundPrimary)

					Spacer()
					AppTheme.shared.imageSet.copyIcon
						.foregroundColor(foregroundPrimary)
				}
			}

			Button(action: buttonSupport) {
				HStack {
					Text("UserProfile.password.change".localized)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(foregroundPrimary)

					Spacer()
					AppTheme.shared.imageSet.arrowRightIcon
						.foregroundColor(foregroundPrimary)
				}
			}
		}
	}

	var twoFactor: some View {
		VStack(spacing: 20) {
			HStack {
			Text("UserProfile.authen.2fa".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundBlack)

				Spacer()
				Button(action: buttonSupport) {
					Text("Disable")
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(foregroundPrimary)
				}
			}
			HStack {
			Text("UserProfile.2FA.title".localized)
					.padding(.trailing, 100)
					.font(AppTheme.shared.fontSet.font(style: .input3))
					.foregroundColor(foregroundGrey1)
				Spacer()
			}
		}
	}
}

// MARK: - Private Func
private extension UserProfileContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
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

	var foregroundPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundBlack: Color {
		AppTheme.shared.colorSet.black
	}

	var foregroundGrey3: Color {
		AppTheme.shared.colorSet.grey3
	}

	var foregroundGrey1: Color {
		AppTheme.shared.colorSet.grey1
	}

	var foregroundColorSetting: Color {
		colorScheme == .light ? foregroundBlack : foregroundWhite
	}

	var foregroundColorPicture: Color {
		colorScheme == .light ? foregroundGrey3 : foregroundWhite
	}
}

struct UserProfileContentView_Previews: PreviewProvider {
	static var previews: some View {
		UserProfileContentView()
	}
}
