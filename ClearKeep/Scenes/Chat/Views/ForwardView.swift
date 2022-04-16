//
//  ForwardView.swift
//  ClearKeep
//
//  Created by MinhDev on 30/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let padding = 20.0
	static let sizeImage = 64.0
	static let spacingContent = 20.0
	static let paddingHorizontal = 40.0
	static let radius = 40.0
	static let boder = 2.0
}

struct ForwardView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var groupText: String
	@Binding var searchText: String
	@Binding var isShowPopup: Bool
	@Binding var inputStyle: TextInputStyle

	// MARK: - Init
	init(imageUser: Binding<Image>,
		 userName: Binding<String>,
		 groupText: Binding<String>,
		 searchText: Binding<String>,
		 isShowPopup: Binding<Bool>,
		 inputStyle: Binding<TextInputStyle>) {
		self._imageUser = imageUser
		self._userName = userName
		self._groupText = groupText
		self._searchText = searchText
		self._isShowPopup = isShowPopup
		self._inputStyle = inputStyle
	}

	// MARK: - Body
	var body: some View {
		content

			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension ForwardView {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Private variable
private extension ForwardView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var foregroundColorButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var backgroundButton: LinearGradient {
		colorScheme == .light ? backgroundButtonLight : backgroundButtonDark
	}

	var backgroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundColorGroupName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var buttonColor: LinearGradient {
		colorScheme == .light ? foregroundButtonLight : foregroundButtonDark
	}

	var foregroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.primaryDefault, AppTheme.shared.colorSet.primaryDefault]), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Private
private extension ForwardView {
	func sendAction() {

	}
}

// MARK: - Loading Content
private extension ForwardView {
	var contentView: some View {
		ZStack(alignment: .bottom) {
			if isShowPopup {
				AppTheme.shared.colorSet.black
					.opacity(0.3)
					.ignoresSafeArea()
					.onTapGesture {
						isShowPopup = true
					}
			}
			ScrollView {
				VStack(alignment: .leading, spacing: Constants.spacing) {
					Text("Chat.Forward".localized)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(foregroundColorGroupName)
					searchView
					Text("Chat.Group".localized)
						.font(AppTheme.shared.fontSet.font(style: .input3))
						.foregroundColor(foregroundColorTitle)
					groupView
					Text("Chat.User".localized)
						.font(AppTheme.shared.fontSet.font(style: .input3))
						.foregroundColor(foregroundColorTitle)
					userView
				}
				.frame(height: 400)
				.frame(maxWidth: .infinity)
				.padding([.leading, .trailing], Constants.padding)
				.background(
					ZStack {
						RoundedRectangle(cornerRadius: 40)
						Rectangle()
							.frame(height: 200)
					}
						.foregroundColor(backgroundColorView)
				)
			}
			.transition(.move(edge: .bottom))
		}
	}

	var searchView: some View {
		SearchTextField(searchText: $searchText,
						inputStyle: $inputStyle,
						inputIcon: AppTheme.shared.imageSet.searchIcon,
						placeHolder: "Chat.Input.PlaceHolder".localized,
						onEditingChanged: { _ in })
	}

	var groupView: some View {
		HStack {
			Text(groupText)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.foregroundColor(foregroundColorGroupName)
			Spacer()
			Button(action: sendAction) {
				Text("Chat.Send".localized)
					.padding(.vertical, Constants.spacing)
					.padding(.horizontal, Constants.paddingHorizontal)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.overlay(
						RoundedRectangle(cornerRadius: Constants.radius)
							.stroke(buttonColor, lineWidth: Constants.boder)
					)
			}
		}
	}

	var userView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			HStack {
				imageUser
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
				Text(userName)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundColorUserName)
				Spacer()
				Button(action: sendAction) {
					Text("Chat.Send".localized)
						.padding(.vertical, Constants.spacing)
						.padding(.horizontal, Constants.paddingHorizontal)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.overlay(
							RoundedRectangle(cornerRadius: Constants.radius)
								.stroke(buttonColor, lineWidth: Constants.boder)
						)
				}
			}
		}
	}
}

// MARK: - Interactor
private extension ForwardView {
}

// MARK: - Preview
#if DEBUG
struct ForwardView_Previews: PreviewProvider {
	static var previews: some View {
		ForwardView(imageUser: .constant(AppTheme.shared.imageSet.faceIcon), userName: .constant(""), groupText: .constant(""), searchText: .constant("Test"), isShowPopup: .constant(false), inputStyle: .constant(.default))
	}
}
#endif
