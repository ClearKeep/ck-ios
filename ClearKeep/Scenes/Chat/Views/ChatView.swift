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
import UniformTypeIdentifiers
// swiftlint:disable file_length

private enum Constants {
	static let padding = 15.0
	static let sizeIconCall = 16.0
	static let sizeBorder = 36.0
	static let lineBorder = 2.0
	static let paddingTop = 50.0
	static let sizeIcon = 24.0
	static let bottomSheetRadius = 30.0
	static let sizeImage = CGSize(width: 36.0, height: 36.0)
	static let forwardViewHeight = UIScreen.main.bounds.height * 0.7
}

struct ChatView: View {
	// MARK: - Environment Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Variables
	@State private(set) var loadable: Loadable<IChatViewModels> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let data):
				if let groupData = data.groupViewModel {
					self.group = groupData
				}
				if data.messageViewModel.isEmpty {
					isEndOfPage = true
				}
				if isNewSentMessage {
					self.dataMessages.insert(contentsOf: data.messageViewModel, at: 0)
					isQuoteMessage = false
					isLatestPeerSignalKeyProcessed = true
				} else {
					self.dataMessages.append(contentsOf: data.messageViewModel)
				}
				isNewSentMessage = false
				isLoading = false
			default: break
			}
		}
	}
		
	@State private(set) var group: IGroupModel?
	@State private(set) var messageText: String
	@State private(set) var inputStyle: TextInputStyle = .default
	
	@State private(set) var dataMessages: [IMessageViewModel] = []
	@State private var selectedMessage: IMessageViewModel?
	@State private var tempSelectedMessage: IMessageViewModel?
	
	@State private var joinedGroups: [ForwardViewModel] = []
	@State private var joinedPeers: [ForwardViewModel] = []
	
	@State private var showingMessageOptions = false
	@State private var scrollToBottom = false
	@State private var isShowingQuoteView = false
	@State private var showingForwardView = false
	@State private var isShowingFloatingButton = false
	@State private var isReplying = false
	@State private var shouldPaginate = false
	@State private var isLoading = false
	@State private var isEndOfPage = false
	@State private var isNewSentMessage = false
	@State private var isQuoteMessage = false
	@State private var isLatestPeerSignalKeyProcessed = false
	
	@State private var showingImageOptions = false
	@State private var isImagePickerPresented = false
	@State private var showingCameraPicker = false
	@State private var selectedImages = [SelectedImageModel]()
	
	private let groupId: Int64
	private let inspection = ViewInspector<Self>()

	// MARK: - Init
	init(messageText: String = "",
		 inputStyle: TextInputStyle,
		 groupId: Int64) {
		self._messageText = .init(initialValue: messageText)
		self._inputStyle = .init(initialValue: inputStyle)
		self.groupId = groupId
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
		}.bottomSheet(
			isPresented: $showingForwardView,
			detents: .custom(Constants.forwardViewHeight),
			shouldScrollExpandSheet: true,
			largestUndimmedDetent: .medium,
			showGrabber: false,
			cornerRadius: Constants.bottomSheetRadius
		) {
			ForwardView(inputStyle: inputStyle, groups: $joinedGroups, users: $joinedPeers, onForwardMessage: { (isGroup, model) in
				if isGroup {
					// forward group message
				} else {
					forwardPeerMessage(model: model)
				}
			}).onAppear {
				getJoinedGroup()
			}
		}
		.fullScreenCover(isPresented: $showingCameraPicker, content: {
			CameraImagePicker(sourceType: .camera) { addImage in
				self.selectedImages.append(addImage)
			}
			.edgesIgnoringSafeArea(.all)
		})
		.onAppear {
			updateGroup()
		}
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension ChatView {
	var content: AnyView {
		switch loadable {
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
				MessageAvatarView(avatarSize: Constants.sizeImage,
								  userName: group?.groupName ?? "",
								  font: AppTheme.shared.fontSet.font(style: .input3),
								  image: group?.groupAvatar ?? ""
				)
				Text(group?.groupName ?? "")
					.lineLimit(1)
					.font(AppTheme.shared.fontSet.font(style: .body1))
					.frame(maxWidth: .infinity, alignment: .leading)
					.foregroundColor(foregroundBackButton)
			}
			.foregroundColor(foregroundBackButton)
		}
	}
	
	var floatingButton: some View {
		Button(action: floatingButtonAction) {
			ZStack {
				AppTheme.shared.imageSet.chevDownIcon
					.resizable()
					.foregroundColor(foregroundFloatingButton)
					.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
				Circle()
					.strokeBorder(foregroundFloatingButton, lineWidth: Constants.lineBorder)
					.frame(width: Constants.sizeBorder, height: Constants.sizeBorder)
			}
		}
	}
	
	var quoteMessageView: some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Text("Chat.Replying".localized + (selectedMessage?.fromClientName ?? ""))
					.font(AppTheme.shared.fontSet.font(style: .placeholder2))
					.foregroundColor(foregroundFloatingButton)
				Spacer()
				Button(action: closeQuoteView) {
					AppTheme.shared.imageSet.closeIcon
						.resizable()
						.foregroundColor(AppTheme.shared.colorSet.grey2)
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
				}.padding([.top, .trailing], 10)
			}
			
			HStack(alignment: .center, spacing: 0) {
				Rectangle()
					.fill(AppTheme.shared.colorSet.grey2)
					.frame(width: 4)
					.cornerRadius(8)
					.padding(.trailing, 16)
				Text(selectedMessage?.getQuoteMessage() ?? "")
					.foregroundColor(foregroundFloatingButton)
					.lineLimit(1)
			}.frame(height: 24)
		}.padding(.horizontal, Constants.padding)
	}
	
	var imagesListView: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(self.selectedImages) { image in
					if let thumbnail = image.thumbnail {
						PreviewImage(image: thumbnail) {
							let selectedIndex = selectedImages.firstIndex(of: image)
							if let index = selectedIndex {
								self.selectedImages.remove(at: index)
							}
						}
					}
				}
			}
			.padding(.horizontal, 16)
		}.introspectScrollView { scrollView in
			scrollView.clipsToBounds = false
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
	
	var foregroundFloatingButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight
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
		showingImageOptions = true
	}
	
	func linkAction() {
		
	}
	
	func userAction() {
		
	}
	
	func forwardPeerMessage(model: IForwardViewModel) {
		Task {
			let encodedMessage = ">>>\(selectedMessage?.message ?? "")"
			let result = await injected.interactors.chatInteractor.forwardPeerMessage(message: encodedMessage, group: model.groupModel)
			if result {
				DispatchQueue.main.async {
					joinedPeers.first { group in
						group.groupModel.groupId == model.groupModel.groupId
					}?.isSent = true
				}
				
			}
		}
	}
	
	func sendAction(message: String) {
		let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
		if !selectedImages.isEmpty {
			isNewSentMessage = true
			Task {
				let selectedImageURL = selectedImages.compactMap { $0.url }
				print(selectedImageURL)
				selectedImages.removeAll()
				loadable = await injected.interactors.chatInteractor.uploadFiles(message: trimmedMessage, fileURLs: selectedImageURL, group: group, isForceProcessKey: !isLatestPeerSignalKeyProcessed)
			}
			return
		}
		
		if trimmedMessage.isEmpty {
			return
		}
		
		isNewSentMessage = true
		Task {
			var encodedMessage = ""
			if isQuoteMessage {
				encodedMessage = "```\(selectedMessage?.fromClientName ?? "")|\(selectedMessage?.message ?? "")|\(selectedMessage?.dateCreated ?? 0)|\(trimmedMessage)"
			} else {
				encodedMessage = trimmedMessage
			}
			loadable = await injected.interactors.chatInteractor.sendMessageInPeer(message: encodedMessage, groupId: groupId, group: group, isForceProcessKey: !isLatestPeerSignalKeyProcessed)
		}
		isShowingQuoteView = false
		isReplying = false
	}
	
	func audioAction() {
		
	}
	
	func videoAction() {
		
	}
	
	func closeQuoteView() {
		isShowingQuoteView = false
		isReplying = false
	}
	
	func floatingButtonAction() {
		scrollToBottom.toggle()
	}
	
	func copyMessage(message: String) {
		UIPasteboard.general.setValue(message, forPasteboardType: UTType.plainText.identifier)
	}
}

// MARK: - Loading Content
private extension ChatView {
	var notRequestedView: some View {
		VStack(alignment: .leading) {
			ZStack {
				MessageListView(messages: dataMessages, hasReachedTop: $shouldPaginate, isShowLoading: $isEndOfPage, showScrollToLatestButton: $isShowingFloatingButton, scrollToLastest: $scrollToBottom) { message in
					self.tempSelectedMessage = message
					showingMessageOptions = true
				}.confirmationDialog("", isPresented: $showingMessageOptions, titleVisibility: .hidden) {
					Button("Chat.CopyButton".localized) {
						copyMessage(message: self.tempSelectedMessage?.message ?? "")
					}
					Button("Chat.ForwardButton".localized) {
						selectedMessage = tempSelectedMessage
						showingForwardView = true
						hideKeyboard()
					}
					Button("Chat.QuoteButton".localized) {
						selectedMessage = tempSelectedMessage
						isShowingQuoteView = true
						isQuoteMessage = true
						isReplying = true
					}
					Button("Chat.Cancel".localized, role: .cancel) {
					}
				}
				VStack(alignment: .trailing) {
					Spacer()
					HStack {
						Spacer()
						floatingButton
					}.padding(.trailing, 10)
					
				}.opacity(isShowingFloatingButton ? 1 : 0)
			}.onTapGesture {
				hideKeyboard()
				isReplying = false
			}
			if !selectedImages.isEmpty {
				imagesListView
			}
			if isShowingQuoteView {
				withAnimation {
					quoteMessageView
				}
			}
			
			MessagerToolBar(message: $messageText,
							isReplying: $isReplying,
							placeholder: "DirectMessages.Placeholder".localized,
							sendAction: { message in
				sendAction(message: message)
			}, sharePhoto: { photoAction() })
			.padding(.horizontal, Constants.padding)
			.confirmationDialog("", isPresented: $showingImageOptions, titleVisibility: .hidden) {
				Button("Chat.TakePhoto".localized) {
					showingCameraPicker = true
				}
				Button("Chat.Albums".localized, role: .destructive) {
					isImagePickerPresented = true
				}
				Button("Chat.Cancel".localized, role: .cancel) {
				}
			}
			.fullScreenCover(isPresented: $isImagePickerPresented) {
				MultipleImagePicker(doneAction: { photo in
					selectedImages = photo.filter { $0.url != nil }
				})
			}
		}.onChange(of: shouldPaginate) { newValue in
			if newValue {
				if !isLoading && !isEndOfPage {
					isLoading.toggle()
					updateMessages()
				}
			}
		}
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: IChatViewModels) -> AnyView {
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
	func updateGroup() {
		Task {
			loadable = await injected.interactors.chatInteractor.updateGroupWithId(groupId: groupId)
		}
	}
	
	func updateMessages() {
		Task {
			loadable = await injected.interactors.chatInteractor.updateMessages(groupId: groupId, group: group, lastMessageAt: dataMessages.last?.dateCreated ?? 0)
		}
	}
	
	func getJoinedGroup() {
		Task {
			let groups = await injected.interactors.chatInteractor.getJoinedGroupsFromLocal()
			self.joinedGroups = groups.filter { $0.groupType == "group" }.sorted { $0.updatedAt > $1.updatedAt }.compactMap { group in
				ForwardViewModel(groupModel: group) }
			self.joinedPeers = groups.filter { $0.groupType == "peer" }.sorted { $0.updatedAt > $1.updatedAt }.compactMap { group in
				ForwardViewModel(groupModel: group) }
		}
	}
}
