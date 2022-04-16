//
//  ChatUserView.swift
//  ClearKeep
//
//  Created by MinhDev on 30/03/2022.
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

struct ChatUserView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject private var keyboardHandler = KeyboardHandler()
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var searchText: String
	@Binding var groupText: String
	@Binding var severText: String
	@Binding var inputStyle: TextInputStyle
	@State private(set) var isShowingLinkUser: Bool = false
	@State private(set) var isShowingUser: Bool = false
	@State private(set) var isShowingPopup: Bool = false
	// MARK: - Init
	init(imageUser: Binding<Image>,
		 userName: Binding<String>,
		 searchText: Binding<String>,
		 groupText: Binding<String>,
		 severText: Binding<String>,
		 inputStyle: Binding<TextInputStyle>) {
		self._imageUser = imageUser
		self._userName = userName
		self._groupText = groupText
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
private extension ChatUserView {
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

	var chatBottomBar: AnyView {
		AnyView(chatBottomBarView)
	}
}

// MARK: - Private Variables
private extension ChatUserView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var backgroundColorListButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var backgroundColorNavigation: LinearGradient {
		colorScheme == .light ? colorGradientPrimary : colorGrey
	}

	var colorGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var colorGrey: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}

	var foregroundText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundSignout: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.primaryDefault
	}
}

// MARK: - Private func
private extension ChatUserView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func sharedAction() {

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
private extension ChatUserView {
	var contentView: some View {
		ZStack {
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
				.background(backgroundColorNavigation)
				chatBottomBarView
					.padding([.leading, .trailing], Constants.padding)
					.padding(.bottom, keyboardHandler.keyboardHeight)
					.animation(.easeOut)
			}
			.padding(.bottom, Constants.padding)

		ForwardView(imageUser: $imageUser, userName: $userName, groupText: $groupText, searchText: $searchText, isShowPopup: $isShowingPopup, inputStyle: .constant(.default))
				.offset(y: 100)

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

//	var chatMessageView: some View {
//		ScrollView {
//			ForEach(0..<20) { num in
//
//			}
//		}
//	}

	var chatBottomBarView: some View {
		HStack {
			Button(action: sharedAction) {
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
private extension ChatUserView {
}

// MARK: - Preview
#if DEBUG
struct ChatUserView_Previews: PreviewProvider {
	static var previews: some View {
		ChatUserView(imageUser: .constant(Image("")), userName: .constant(""), searchText: .constant(""), groupText: .constant("false"), severText: .constant(""), inputStyle: .constant(.default))
	}
}
#endif
