//
//  ChatGroupView.swift
//  ClearKeep
//
//  Created by MinhDev on 30/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacer = 25.0
	static let padding = 15.0
	static let sizeImage = 36.0
	static let sizeIconCall = 5.0
	static let sizeBorder = 36.0
	static let lineBorder = 2.0
	static let paddingHorizontal = 40.0
	static let paddingTop = 50.0
	static let sizeIcon = 24.0
}

struct ChatGroupView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject private var keyboardHandler = KeyboardHandler()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var searchText: String
	@Binding var severText: String
	@Binding var inputStyle: TextInputStyle
	@State private(set) var isShowingLinkUser: Bool = false
	@State private(set) var isShowingUser: Bool = false
	@State private(set) var isShowingSelectPhotos: Bool = false

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
private extension ChatGroupView {
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
		AnyView(listButtonView)
	}
}

// MARK: - Private Variables
private extension ChatGroupView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}

	var foregroundButtonImage: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
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

	var backgroundGradientPrimary: LinearGradient {
			LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
		}
}

// MARK: - Private func
private extension ChatGroupView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func photoAction() {
		isShowingSelectPhotos.toggle()
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
private extension ChatGroupView {
	var contentView: some View {
		VStack {
			HStack {
				buttonBack
				HStack {
					audioButton
						.foregroundColor(foregroundBackButton)
						.padding(.trailing, 15)
					videoButton
						.foregroundColor(foregroundBackButton)
				}
			}
			.padding(.top, Constants.paddingTop)
			.padding([.leading, .trailing, .bottom], Constants.padding)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(backgroundGradientPrimary)
			Spacer()
			listButton
				.padding([.leading, .trailing], Constants.padding)
				.padding(.bottom, keyboardHandler.keyboardHeight)
				.animation(.easeOut)
		}
		.padding(.bottom, Constants.padding)
	}

	var audioButtonView: some View {
		Button(action: audioAction) {
			ZStack {
				AppTheme.shared.imageSet.phoneCallIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundButton)
					.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
				Circle()
					.strokeBorder(foregroundButton, lineWidth: Constants.lineBorder)
					.frame(width: Constants.sizeBorder, height: Constants.sizeBorder)
			}
		}
	}

	var videoButtonView: some View {
		Button(action: videoAction) {
			ZStack {
				AppTheme.shared.imageSet.videoIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundButton)
					.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
				Circle()
					.strokeBorder(foregroundButton, lineWidth: Constants.lineBorder)
					.frame(width: Constants.sizeBorder, height: Constants.sizeBorder)
			}
		}
	}

	var listButtonView: some View {
		HStack {
			if #available(iOS 15.0, *) {
				Button(action: photoAction) {
					AppTheme.shared.imageSet.photoIcon
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
						.foregroundColor(foregroundText)
				}
				.confirmationDialog("", isPresented: $isShowingSelectPhotos) {
					Button { }
				label: {
						Text("Take a photo")
					}

					Button { }
				label: {
						Text("Albums")
						.foregroundColor(.red)
					}
					Button("Cancel", role: .cancel) {}
				}
			} else {
				// Fallback on earlier versions
			}

			Button(action: linkAction) {
				AppTheme.shared.imageSet.linkIcon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
					.foregroundColor(foregroundText)
			}
			CommonTextField(text: $severText,
							inputStyle: $inputStyle,
							placeHolder: "DirectMessages.Placeholder".localized,
							onEditingChanged: { _ in })
				.frame(maxWidth: .infinity)
			Button(action: sendAction) {
				AppTheme.shared.imageSet.sendIcon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
					.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
			}
		}
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack {
				AppTheme.shared.imageSet.chevleftIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				AppTheme.shared.imageSet.facebookIcon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
				Text(userName)
					.font(AppTheme.shared.fontSet.font(style: .display3))
					.frame(maxWidth: .infinity, alignment: .leading)
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Interactor
private extension ChatGroupView {
}

// MARK: - Preview
#if DEBUG
struct ChatGroupView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupView(imageUser: .constant(Image("")), userName: .constant(""), searchText: .constant(""), severText: .constant(""), inputStyle: .constant(.default))
	}
}
#endif
