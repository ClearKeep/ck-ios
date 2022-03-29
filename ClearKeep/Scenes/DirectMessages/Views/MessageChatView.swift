//
//  MessageChatView.swift
//  ClearKeep
//
//  Created by MinhDev on 29/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let padding = 20.0
	static let sizeImage = 36.0
	static let sizeIconCall = 16.0
	static let sizeBoder = 36.0
	static let lineBoder = 2.0
	static let paddingHorizontal = 40.0
	static let paddingTop = 50.0
	static let sizeIcon = 24.0
}

struct MessageChatView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var searchText: String
	@Binding var severText: String
	@Binding var inputStyle: TextInputStyle
	@State private(set) var isShowingLinkUser: Bool = false
	@State private(set) var isShowingUser: Bool = false
	// MARK: - Init
	init(imageUser: Binding<Image>,
		 userName: Binding<String>,
		 searchText: Binding<String>,
		 severText: Binding<String>,
		 inputStyle: Binding<TextInputStyle>) {
		self._imageUser = imageUser
		self._userName = userName
		self._searchText = searchText
		self._severText = severText
		self._inputStyle = inputStyle
	}

	// MARK: - Body
	var body: some View {
		content
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.edgesIgnoringSafeArea(.all)
			.background(backgroundColorView)
	}
}

// MARK: - Private
private extension MessageChatView {
	var content: AnyView {
		AnyView(contentView)
	}

	var buttonBack: AnyView {
		AnyView(buttonBackView)
	}

	var audioButton: AnyView {
		AnyView(audioButtonView)
	}

	var videoButton: AnyView {
		AnyView(videoButtonView)
	}
	var listButton: AnyView {
		AnyView(listbuttonView)
	}
}

// MARK: - Private Variables
private extension MessageChatView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}

	var foregroundButtonImage: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}

	var foregroundText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundSignout: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.errorDefault : AppTheme.shared.colorSet.primaryDefault
	}
}

// MARK: - Private func
private extension MessageChatView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func photoAction() {

	}

	func linkAction() {

	}

	func sendAction() {

	}

	func audioAction() {

	}

	func videoAction() {

	}
}

// MARK: - Loading Content
private extension MessageChatView {
	var contentView: some View {
		VStack {
			HStack {
				buttonBack
				Spacer()
				audioButton
					.foregroundColor(foregroundBackButton)
				videoButton
					.foregroundColor(foregroundBackButton)
			}
			.padding(.top, Constants.paddingTop)
			.padding([.leading, .trailing, .bottom], Constants.padding)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(AppTheme.shared.colorSet.primaryDefault)
			Spacer()
			listButton
				.padding([.leading, .trailing, .bottom], Constants.padding)
		}
	}

	var audioButtonView: some View {
		Button(action: audioAction) {
				ZStack {
					AppTheme.shared.imageSet.phoneCallIcon
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.foregroundColor(foregroundButton)
						.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
					Circle()
						.strokeBorder(foregroundButton, lineWidth: Constants.lineBoder)
						.frame(width: Constants.sizeBoder, height: Constants.sizeBoder)
			}
		}
	}

	var videoButtonView: some View {
		Button(action: videoAction) {
				ZStack {
					AppTheme.shared.imageSet.videoIcon
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.foregroundColor(foregroundButton)
						.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
					Circle()
						.strokeBorder(foregroundButton, lineWidth: Constants.lineBoder)
						.frame(width: Constants.sizeBoder, height: Constants.sizeBoder)
			}
		}
	}

	var listbuttonView: some View {
		HStack {
			Button(action: photoAction) {
				AppTheme.shared.imageSet.photoIcon
					.resizable()
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
					.padding(.all, Constants.padding)
					.foregroundColor(foregroundText)
			}

			Button(action: linkAction) {
				AppTheme.shared.imageSet.linkIcon
					.resizable()
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
					.padding(.all, Constants.padding)
					.foregroundColor(foregroundText)
			}
			CommonTextField(text: $severText,
							inputStyle: $inputStyle,
							placeHolder: "DirectMessages.Placeholder".localized,
							onEditingChanged: { _ in })
			Button(action: sendAction) {
				AppTheme.shared.imageSet.sendIcon
					.resizable()
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
					.padding(.all, Constants.padding)
					.foregroundColor(foregroundSignout)
			}
		}
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacing) {
				AppTheme.shared.imageSet.chevleftIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				AppTheme.shared.imageSet.facebookIcon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
				Text(userName)
					.font(AppTheme.shared.fontSet.font(style: .body1))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Interactor
private extension MessageChatView {
}

// MARK: - Preview
#if DEBUG
struct MessageChatView_Previews: PreviewProvider {
	static var previews: some View {
		MessageChatView(imageUser: .constant(Image("")), userName: .constant(""), searchText: .constant(""), severText: .constant(""), inputStyle: .constant(.default))
	}
}
#endif
