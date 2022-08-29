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
import ChatSecure
import RealmSwift
import AVFoundation

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
	static let filePickerViewHeight = UIScreen.main.bounds.height * 0.6
}

// swiftlint:disable file_length
struct ChatView: View {
	// MARK: - Environment Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Variables
	@State private(set) var loadable: Loadable<IGroupModel?> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let data):
				isShowLoading = false
				group = data
				DispatchQueue.main.async {
					loadLocalMessage(groupId: data?.groupId ?? 0)
				}
			case .failed(let error):
				self.errorType = ChatErrorView(error)
				alertVisible = true
			default: break
			}
		}
	}
	
	@State private(set) var sendMessageLoadable: Loadable<Void> = .notRequested {
		didSet {
			switch sendMessageLoadable {
			case .failed(let error):
				self.errorType = ChatErrorView(error)
				alertVisible = true
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
	
	@State private var showingFilePicker = false
	@State private var showingMessageOptions = false
	@State private var scrollToBottom = false
	@State private var isShowingQuoteView = false
	@State private var showingForwardView = false
	@State private var isShowingFloatingButton = false
	@State private var isReplying = false
	@State private var shouldPaginate = false
	@State private var isMessageLoading = false
	@State private var isEndOfPage = false
	@State private var isNewSentMessage = false
	@State private var isQuoteMessage = false
	@State private var isLatestPeerSignalKeyProcessed = false
	@State private var showingLinkWebView = false
	@State private var showingImageOptions = false
	@State private var isImagePickerPresented = false
	@State private var showingCameraPicker = false
	@State private var isFirstLoad = true
	@State private var isShowLoading = false
	
	@State private var selectedImages = [SelectedImageModel]()
	@State private var isDetail = false
	@State private var selectedLink: URL?
	@State private var messages: Results<RealmMessage>?
	@State private var notificationToken: NotificationToken?
	@State private var isFirstLoadData: Bool = true
	@State private var isShowingCall: Bool = false
	@State private var alertVisible = false
	@State private var hudVisible = false
	@State private var disableCall = false
	@State private var errorType: ChatErrorView = .locked
	@State private var rediectMessageId = ""
	@State private var isShowDownloadToast = false
	
	private let groupId: Int64
	private let avatarLink: String
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Init
	init(messageText: String = "",
		 inputStyle: TextInputStyle,
		 groupId: Int64,
		 avatarLink: String) {
		self._messageText = .init(initialValue: messageText)
		self._inputStyle = .init(initialValue: inputStyle)
		self.groupId = groupId
		self.avatarLink = avatarLink
	}
	
	// MARK: - Body
	var body: some View {
		NavigationView {
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
				showGrabber: false,
				cornerRadius: Constants.bottomSheetRadius
			) {
				ForwardView(inputStyle: inputStyle, groups: $joinedGroups, users: $joinedPeers, onForwardMessage: { (isGroup, model) in
					if isGroup {
						forwardGroupMessage(model: model)
					} else {
						forwardPeerMessage(model: model)
					}
				}).onAppear {
					getJoinedGroup()
				}
			}
			.bottomSheet(
				isPresented: $showingFilePicker,
				detents: .custom(Constants.filePickerViewHeight),
				shouldScrollExpandSheet: true,
				showGrabber: true,
				cornerRadius: Constants.bottomSheetRadius
			) {
				FilePickerContainerView { files in
					if files.isEmpty { return }
					print(files)
					isNewSentMessage = true
					Task {
						sendMessageLoadable = await injected.interactors.chatInteractor.uploadFiles(message: "", fileURLs: files, group: group, appendFileSize: true, isForceProcessKey: !isLatestPeerSignalKeyProcessed)
					}
				}
			}
			.fullScreenCover(isPresented: $showingCameraPicker, content: {
				CameraImagePicker(sourceType: .camera) { addImage in
					self.selectedImages.append(addImage)
				}
				.edgesIgnoringSafeArea(.all)
			})
			.sheet(isPresented: $showingLinkWebView, content: {
				if let url = selectedLink {
					WebView(url: url)
						.edgesIgnoringSafeArea(.all)
				}
			})
			.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.SubscribeAndListenService.didReceiveNotification)) { (obj) in
				print("received...... \(obj)")
				if let userInfo = obj.userInfo,
				   let publication = userInfo["notification"] as? Notification_NotifyObjectResponse {
					if publication.notifyType == "peer-update-key" {
						self.isLatestPeerSignalKeyProcessed = false
					}
				}
			}
			.onReceive(NotificationCenter.default.publisher(for: NSNotification.alertChat, object: nil), perform: { _ in
				self.errorType = .removed
				self.alertVisible = true
			})
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.alert(isPresented: $alertVisible, content: {
				switch errorType {
				case .permission:
					return Alert(title: Text(errorType.title),
								 message: Text(errorType.message),
								 primaryButton: .default(Text("Call.Settings".localized), action: {
						guard let url = URL(string: UIApplication.openSettingsURLString) else {
							return
						}
						UIApplication.shared.open(url)
					}),
								 secondaryButton: .default(Text("Call.Cancel".localized)))
				default:
					return Alert(title: Text(errorType.title),
								 message: Text(errorType.message),
								 dismissButton: .default(Text(errorType.primaryButtonTitle)))
				}
			})
			.toast(message: "Chat.DownloadSuccess".localized, isShowing: $isShowDownloadToast, duration: Toast.short)
			.progressHUD(isShowLoading)
		}
		.hiddenNavigationBarStyle()
		.edgesIgnoringSafeArea(.all)
		.onChange(of: groupId, perform: { newValue in
			messages = nil
			dataMessages.removeAll()
			selectedImages.removeAll()
			isLatestPeerSignalKeyProcessed = false
			isEndOfPage = false
			shouldPaginate = false
			isFirstLoad = true
			updateGroup(groupId: newValue)
		})
		.onAppear {
			if isFirstLoadData {
				updateGroup(groupId: self.groupId)
				isFirstLoadData = false
			}
		}
		.onDisappear {
			injected.interactors.chatInteractor.saveDraftMessage(message: messageText, roomId: groupId)
			notificationToken?.invalidate()
			DependencyResolver.shared.messageService.updateCurrentRoom(roomId: 0)
		}
	}
}

// MARK: - Private
private extension ChatView {
	var content: AnyView {
		AnyView(notRequestedView)
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
		}.disabled(self.disableCall)
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
		}.disabled(disableCall)
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
		NavigationLink(destination: GroupDetailView(groupId: group?.groupId ?? 0),
					   isActive: $isDetail) {
			Button(action: userAction) {
				HStack(spacing: 20) {
					let member = self.getPartnerUser(group: self.group)
					MessageAvatarView(avatarSize: Constants.sizeImage,
									  userName: group?.groupType == "peer" ? member == nil ? "Deleted user" : member?.userName ?? "" : group?.groupName ?? "",
									  font: AppTheme.shared.fontSet.font(style: .input3),
									  image: group?.groupAvatar ?? ""
					)
					Text(group?.groupType == "peer" ? member == nil ? "Deleted user" : member?.userName ?? "" : group?.groupName ?? "")
						.lineLimit(1)
						.font(AppTheme.shared.fontSet.font(style: .body1))
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(foregroundBackButton)
				}
				.foregroundColor(foregroundBackButton)
			}
		}
					   .disabled( disableButton() )
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
				Text("Chat.Replying".localized + ((selectedMessage?.isMine ?? false) ? "You" : (selectedMessage?.fromClientName ?? "")))
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
	
	func fileAction() {
		showingFilePicker = true
	}
	
	func userAction() {
		isDetail.toggle()
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
	
	func forwardGroupMessage(model: IForwardViewModel) {
		Task {
			let encodedMessage = ">>>\(selectedMessage?.message ?? "")"
			let isJoined = model.groupModel.isJoined
			let result = await injected.interactors.chatInteractor.forwardGroupMessage(message: encodedMessage, groupId: model.groupModel.groupId, isJoined: isJoined)
			if result {
				DispatchQueue.main.async {
					joinedGroups.first { group in
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
				sendMessageLoadable = await injected.interactors.chatInteractor.uploadFiles(message: trimmedMessage, fileURLs: selectedImageURL, group: group, appendFileSize: false, isForceProcessKey: !isLatestPeerSignalKeyProcessed)
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
				encodedMessage = "```\(selectedMessage?.fromClientName ?? "")|\(selectedMessage?.message ?? "")|\(selectedMessage?.dateCreated ?? 0)|\(selectedMessage?.id ?? "")|\(trimmedMessage)"
			} else {
				encodedMessage = trimmedMessage
			}
			if group?.groupType == "peer" {
				sendMessageLoadable = await injected.interactors.chatInteractor.sendMessageInPeer(message: encodedMessage, groupId: groupId, group: group, isForceProcessKey: !isLatestPeerSignalKeyProcessed)
			} else {
				let isJoined = group?.isJoined ?? false
				sendMessageLoadable = await injected.interactors.chatInteractor.sendMessageInGroup(message: encodedMessage, groupId: groupId, isJoined: isJoined, isForward: false)
			}
		}
		isShowingQuoteView = false
		isReplying = false
	}
	
	private func call(callType type: CallType) {
		if CallManager.shared.calls.count > 0 || CallManager.shared.awaitCallGroup == Int(self.groupId) {
			self.errorType = .haveExistACall
			alertVisible = true
			self.disableCall = false
			return
		}
		
		CallManager.shared.awaitCallGroup = Int(self.groupId)
		AVCaptureDevice.authorizeVideo(completion: { (status) in
			AVCaptureDevice.authorizeAudio(completion: { (status) in
				if status == .alreadyAuthorized || status == .justAuthorized {
					hudVisible = true
					Task {
						let response = await self.injected.interactors.chatInteractor.requestVideoCall(isCallGroup: group?.groupType != "peer",
																									   clientId: DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "",
																									   clientName: self.group?.groupName ?? "",
																									   avatar: self.group?.groupAvatar ?? "",
																									   groupId: self.groupId,
																									   callType: type)
						switch response {
						case .success:
							hudVisible = false
							self.disableCall = false
							CallManager.shared.awaitCallGroup = nil
						case .failure(let error):
							hudVisible = false
							self.disableCall = false
							CallManager.shared.awaitCallGroup = nil
							print(error)
						}
					}
				} else {
					self.errorType = .permission
					self.alertVisible = true
					self.disableCall = false
					CallManager.shared.awaitCallGroup = nil
				}
			})
		})
	}
	
	func videoAction() {
		self.disableCall = true
		self.call(callType: .video)
	}
	
	func audioAction() {
		self.disableCall = true
		self.call(callType: .audio)
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
	
	func disableButton() -> Bool {
		return group?.groupType == "peer" ? true : false
	}
}

// MARK: - Loading Content
private extension ChatView {
	var notRequestedView: some View {
		VStack(alignment: .leading) {
			ZStack {
				MessageListView(messages: dataMessages,
								hasReachedTop: $shouldPaginate,
								isShowLoading: $isEndOfPage,
								showScrollToLatestButton: $isShowingFloatingButton,
								scrollToLastest: $scrollToBottom,
								rediectMessageId: $rediectMessageId,
								onPressFile: { url in
					Task {
						let result = await injected.interactors.chatInteractor.downloadFile(urlString: url)
						if result {
							isShowDownloadToast = true
						} else {
							self.errorType = .downloadFail
							alertVisible = true
						}
					}
				}, onClickLink: { url in
					showingLinkWebView = true
					selectedLink = url
				}, onLongPress: { message in
					tempSelectedMessage = message
					showingMessageOptions = true
				}, onTapQuoteMessage: { messageId in
					rediectMessageId = messageId
				})
					.confirmationDialog("", isPresented: $showingMessageOptions, titleVisibility: .hidden) {
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
			}, sharePhoto: { photoAction() },
							shareFile: { fileAction() }
			)
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
			if isFirstLoad {
				isFirstLoad = false
				return
			}
			if newValue {
				if !isMessageLoading && !isEndOfPage {
					isMessageLoading.toggle()
					updateMessages()
				}
			}
		}
	}
}

// MARK: - Interactor
private extension ChatView {
	func updateGroup(groupId: Int64) {
		isShowLoading = true
		if let draftMessage = injected.interactors.chatInteractor.getDraftMessage(roomId: groupId) {
			messageText = draftMessage
		}
		Task {
			loadable = await injected.interactors.chatInteractor.updateGroupWithId(groupId: groupId)
			group?.groupAvatar = self.avatarLink
		}
	}
	
	func loadLocalMessage(groupId: Int64) {
		print("load local message")
		messages = injected.interactors.chatInteractor.getMessageFromLocal(groupId: groupId)
		messages?.filter { !$0.message.isEmpty }.forEach({ message in
			dataMessages.append(MessageViewModel(data: message, members: group?.groupMembers ?? []))
		})
		if dataMessages.count < 20 {
			isEndOfPage = true
		}
		notificationToken = messages?.observe({ changes in
			switch changes {
			case .initial:
				if dataMessages.count > 0 {
					return
				}
				if messages?.count ?? 0 < 20 {
					isEndOfPage = true
				}
				messages?.filter { !$0.message.isEmpty }.forEach({ message in
					dataMessages.append(MessageViewModel(data: message, members: group?.groupMembers ?? []))
				})
			case .update(_, _, insertions: let insertions, _):
				print("messages update: \(insertions)")
				if insertions.count >= 20 {
					isEndOfPage = false
				}
				if let newMessages = messages?.objects(at: IndexSet(insertions)) {
					if insertions.first ?? 0 >= dataMessages.count {
						newMessages.filter { !$0.message.isEmpty }.forEach { message in
							dataMessages.append(MessageViewModel(data: message, members: group?.groupMembers ?? []))
						}
					} else {
						newMessages.filter { !$0.message.isEmpty }.forEach { message in
							dataMessages.insert(MessageViewModel(data: message, members: group?.groupMembers ?? []), at: 0)
						}
						scrollToBottom = true
					}
				}
				if isNewSentMessage {
					isQuoteMessage = false
					isLatestPeerSignalKeyProcessed = true
					isNewSentMessage = false
				}
			case .error(let error):
				print("load message error: \(error)")
			}
			isMessageLoading = false
		})
	}
	
	func updateMessages() {
		Task {
			let isGroup = group?.groupType == "group"
			await injected.interactors.chatInteractor.updateMessages(loadable: $loadable, isEndOfPage: $isEndOfPage, groupId: groupId, isGroup: isGroup, lastMessageAt: dataMessages.last?.dateCreated ?? 0)
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
	
	func getPartnerUser(group: IGroupModel?) -> IMemberModel? {
		return group?.groupMembers.first(where: { $0.userId != DependencyResolver.shared.channelStorage.currentServer?.profile?.userId })
	}
}
extension NSNotification {
	static let alertChat = Notification.Name.init("alertChat")
}
