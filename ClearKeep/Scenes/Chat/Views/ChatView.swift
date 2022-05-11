//
//  ChatView.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import SwiftUI
import Common
import CommonUI
import Combine
import Model
import Networking

private enum Constants {
	static let padding = 15.0
	static let sizeImage = 36.0
	static let sizeIconCall = 16.0
	static let sizeBorder = 36.0
	static let lineBorder = 2.0
	static let paddingTop = 50.0
	static let sizeIcon = 24.0
}

struct ChatView: View {
	// MARK: - Environment Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Variables
	@State private(set) var samples: Loadable<[IMessageViewModel]>
	@State private(set) var messageText: String
	@State private(set) var inputStyle: TextInputStyle = .default
	private let imageUser: Image
	private let userName: String
	private let inspection = ViewInspector<Self>()
	
	@State private(set) var sampleMessages: [MessageViewModel] = createSamplesData()

	// MARK: - Init
	init(samples: Loadable<[IMessageViewModel]> = .notRequested,
		 messageText: String = "",
		 inputStyle: TextInputStyle,
		 imageUser: Image,
		 userName: String) {
		self._samples = .init(initialValue: samples)
		self._messageText = .init(initialValue: messageText)
		self._inputStyle = .init(initialValue: inputStyle)
		self.imageUser = imageUser
		self.userName = userName
	}
	
	// MARK: - Fake data
	private static func createSamplesData() -> [MessageViewModel] {
		return	[
			MessageViewModel(data: MessageModel(id: "1", groupID: 1, groupType: "", fromClientID: "2", clientID: "2", message: Data("someString".utf8), createdAt: 1421415235, updatedAt: 121124235235, clientWorkspaceDomain: "3")),
			MessageViewModel(data: MessageModel(id: "2", groupID: 1, groupType: "", fromClientID: "1", clientID: "2", message: Data("Lorem ipsum dolor sit amet".utf8), createdAt: 1421415235, updatedAt: 121124235235, clientWorkspaceDomain: "3")),
			MessageViewModel(data: MessageModel(id: "3", groupID: 1, groupType: "", fromClientID: "2", clientID: "2", message: Data("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".utf8), createdAt: 1421415235, updatedAt: 121124235235, clientWorkspaceDomain: "3"))
		]
	}
	
	// MARK: - Body
	var body: some View {
		ZStack {
			backgroundColorView.edgesIgnoringSafeArea(.all)
			content
				.edgesIgnoringSafeArea([.trailing, .leading, .top])
				.applyNavigationBarGradidentStyle(leftBarItems: {
					HStack {
						buttonBackView
						buttonUserView
					}
				}, rightBarItems: {
					HStack(spacing: 24) {
						audioButtonView
						videoButtonView
					}
				})
		}.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension ChatView {
	var content: AnyView {
		switch samples {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(data)
		case .failed(let error):
			guard let error = error as? IServerError else {
				return AnyView(errorView(ServerError.unknown))
			}
			return AnyView(errorView(error))
		}
	}
	
	var audioButtonView: some View {
		Button(action: audioAction) {
			ZStack {
				AppTheme.shared.imageSet.phoneCallIcon
					.resizable()
					.foregroundColor(foregroundButton)
					.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
				Circle()
					.strokeBorder(foregroundButton, lineWidth: Constants.lineBorder)
					.frame(width: Constants.sizeBorder, height: Constants.sizeBorder)
			}.foregroundColor(foregroundBackButton)
		}
	}
	
	var videoButtonView: some View {
		Button(action: videoAction) {
			ZStack {
				AppTheme.shared.imageSet.videoIcon
					.resizable()
					.foregroundColor(foregroundButton)
					.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
				Circle()
					.strokeBorder(foregroundButton, lineWidth: Constants.lineBorder)
					.frame(width: Constants.sizeBorder, height: Constants.sizeBorder)
			}.foregroundColor(foregroundBackButton)
		}
	}
	
	var buttonBackView: some View {
		Button(action: customBack) {
			AppTheme.shared.imageSet.chevleftIcon
				.resizable()
				.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
				.foregroundColor(foregroundBackButton)
		}
	}
	
	var buttonUserView: some View {
		Button(action: userAction) {
			HStack(spacing: 20) {
				imageUser
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
				Text(userName)
					.lineLimit(1)
					.font(AppTheme.shared.fontSet.font(style: .body1))
					.frame(maxWidth: .infinity, alignment: .leading)
					.foregroundColor(foregroundBackButton)
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Color Variables
private extension ChatView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}
	
	var backgroundGradientPrimary: AnyView {
		colorScheme == .light
		? AnyView(LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing))
		: AnyView(AppTheme.shared.colorSet.darkGrey2)
	}
}

// MARK: - Private func
private extension ChatView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func photoAction() {
		
	}
	
	func linkAction() {
		
	}
	
	func userAction() {
		
	}
	
	func sendAction(message: String) {
		let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
		if trimmedMessage.isEmpty {
			return
		}
		sampleMessages.append(MessageViewModel(data: MessageModel(id: "\(UUID())", groupID: 1, groupType: "", fromClientID: "1", clientID: "2", message: Data(trimmedMessage.utf8), createdAt: 1421415235, updatedAt: 121124235235, clientWorkspaceDomain: "3")))
	}
	
	func audioAction() {
		
	}
	
	func videoAction() {
		
	}
}

// MARK: - Loading Content
private extension ChatView {
	
	var notRequestedView: some View {
		VStack {
			ScrollViewReader { scrollView in
				ScrollView(.vertical) {
					MessageListView(messages: sampleMessages) { model in
						MessageBubbleView(messageViewModel: model.message, rectCorner: model.rectCorner)
					}.id("MessageListView")
					Spacer()
				}
				.onAppear {
					withAnimation {
						scrollView.scrollTo("MessageListView", anchor: .bottom)
					}
				}
				.onChange(of: sampleMessages) { _ in
					withAnimation {
						scrollView.scrollTo("MessageListView", anchor: .bottom)
					}
				}
			}.hideKeyboardOnTapped()
			MessagerToolBar(placeholder: "DirectMessages.Placeholder".localized,
							sendAction: { message in
				sendAction(message: message)
			}, sharePhoto: { }).padding(.horizontal, 18)
		}
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: [IMessageViewModel]) -> AnyView {
		return AnyView(notRequestedView)
	}
	
	func errorView(_ error: IServerError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text("General.Error".localized),
					  message: Text(error.message ?? "General.Unknown".localized),
					  dismissButton: .default(Text("General.OK".localized)))
			}
	}
}

// MARK: - Interactor
private extension ChatView {
}

// MARK: - Preview
#if DEBUG
struct ChatView_Previews: PreviewProvider {
	static var previews: some View {
		ChatView(messageText: "", inputStyle: .default, imageUser: AppTheme.shared.imageSet.facebookIcon, userName: "Mark")
	}
}
#endif
