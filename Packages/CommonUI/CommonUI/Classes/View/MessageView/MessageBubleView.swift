//
//  MessageBubleView.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI
import Common

private enum Constants {
	static let messageDateSpacing = 2.0
	static let groupMessageDateSpacing = 4.0
	static let groupMessageLeadingSpacing = 24.0
	static let forwardMessageIndicatorHeight = 24.0
	static let spacer = 8.0
	static let messageIndicatorRadius = 8.0
	static let messageIndicatorWidth = 4.0
	static let avatarSize = CGSize(width: 16.0, height: 16.0)
	static let statusSize = CGSize(width: 8.0, height: 8.0)
	static let maxWidthBuble = UIScreen.main.bounds.width * 0.67
}

public struct MessageBubbleView: View {
	@Environment(\.colorScheme) var colorScheme
	
	@State private var contentSizeThatFits: CGSize = .zero
	var messageViewModel: IMessageViewModel
	var isGroup: Bool = false
	var isShowAvatarAndUserName: Bool = false
	var rectCorner: UIRectCorner
	var onTapFile: (String) -> Void
	var onTapLink: (URL) -> Void
	var onTapQuoteMessage: (String) -> Void
		
	public init(messageViewModel: IMessageViewModel,
				rectCorner: UIRectCorner,
				onTapFile: @escaping (String) -> Void,
				onTapLink: @escaping (URL) -> Void,
				onTapQuoteMessage: @escaping (String) -> Void) {
		self.messageViewModel = messageViewModel
		self.isGroup = messageViewModel.groupType == "group"
		self.rectCorner = rectCorner
		self.onTapFile = onTapFile
		self.onTapLink = onTapLink
		self.onTapQuoteMessage = onTapQuoteMessage
	}
	
	public var body: some View {
		HStack(alignment: .top) {
			if messageViewModel.isMine {
				if messageViewModel.isQuoteMessage {
					senderQuoteMessageView
				} else {
					senderMessageView
				}
			} else {
				if isGroup {
					if messageViewModel.isQuoteMessage {
						groupQuoteMessageView
					} else {
						groupReceiverMessageView
					}
				} else {
					if messageViewModel.isQuoteMessage {
						receiverQuoteMessageView
					} else {
						receiverMessageView
					}
				}
			}
		}
		.id(messageViewModel.id)
	}
}

// MARK: - Private view
private extension MessageBubbleView {
	
	var senderMessageView: some View {
		HStack {
			Spacer()
			VStack(alignment: .trailing, spacing: Constants.messageDateSpacing) {
				HStack {
					if messageViewModel.isForwardedMessage {
						forwardTitleView
					}
					dateCreatedView
				}
				if messageViewModel.isImageMessage {
					imageContentView(isMine: true)
				} else if messageViewModel.isFileMessage {
					fileContentView(isMine: true)
				} else {
					messageContentView(isMine: true)
						.frame(width: Constants.maxWidthBuble, alignment: .trailing)
				}
			}
		}
	}
	
	var receiverMessageView: some View {
		VStack(alignment: .leading, spacing: Constants.messageDateSpacing) {
			HStack {
				if messageViewModel.isForwardedMessage {
					forwardTitleView
				}
				dateCreatedView
			}
			HStack {
				if messageViewModel.isImageMessage {
					imageContentView(isMine: false)
				} else if messageViewModel.isFileMessage {
					fileContentView(isMine: false)
				} else {
					messageContentView(isMine: false)
						.frame(width: Constants.maxWidthBuble, alignment: .leading)
				}
				Spacer()
			}
		}
	}
	
	var senderQuoteMessageView: some View {
		HStack {
			Spacer()
			VStack(alignment: .trailing, spacing: Constants.messageDateSpacing) {
				dateCreatedView
				
				HStack(spacing: 0) {
					quoteContentView
					Rectangle()
						.fill(commonUIConfig.colorSet.grey2)
						.frame(width: Constants.messageIndicatorWidth)
						.cornerRadius(Constants.messageIndicatorRadius)
				}
				Text(messageViewModel.getQuoteMessageReply())
					.modifier(MessageTextViewModifier())
					.background(commonUIConfig.colorSet.grey2)
					.clipShape(BubbleArrow(rectCorner: rectCorner))
					.foregroundColor(foregroundText)
				
			}.frame(width: Constants.maxWidthBuble, alignment: .trailing)
		}
	}
	
	var receiverQuoteMessageView: some View {
		HStack {
			VStack(alignment: .leading, spacing: Constants.messageDateSpacing) {
				dateCreatedView
				
				HStack(spacing: 0) {
					Rectangle()
						.fill(commonUIConfig.colorSet.grey2)
						.frame(width: Constants.messageIndicatorWidth)
						.cornerRadius(Constants.messageIndicatorRadius)
					
					quoteContentView
				}
				Text(messageViewModel.getQuoteMessageReply())
					.modifier(MessageTextViewModifier())
					.background(commonUIConfig.colorSet.primaryDefault)
					.clipShape(BubbleArrow(rectCorner: rectCorner))
					.foregroundColor(foregroundText)
				
			}.frame(width: Constants.maxWidthBuble, alignment: .leading)
			Spacer()
		}
	}
	
	var groupReceiverMessageView: some View {
		HStack {
			VStack(alignment: .leading, spacing: Constants.messageDateSpacing) {
				HStack(spacing: 0) {
					MessageAvatarView(avatarSize: Constants.avatarSize,
									  statusSize: Constants.statusSize,
									  userName: messageViewModel.fromClientName,
									  font: commonUIConfig.fontSet.font(style: .input3),
									  image: ""
					).padding(.trailing, Constants.spacer)
					
					if messageViewModel.isForwardedMessage {
						forwardTitleView
					} else {
						Text(messageViewModel.fromClientName)
							.font(commonUIConfig.fontSet.font(style: .input3))
							.foregroundColor(commonUIConfig.colorSet.successDefault)
					}
					dateCreatedView
						.padding(.leading, Constants.groupMessageDateSpacing)
					
					Spacer()
				}.padding(.top, Constants.spacer)
				
				if messageViewModel.isImageMessage {
					imageContentView(isMine: false)
				} else if messageViewModel.isFileMessage {
					fileContentView(isMine: false)
				} else {
					messageContentView(isMine: false)
						.padding(.leading, Constants.groupMessageLeadingSpacing)
						.frame(width: Constants.maxWidthBuble, alignment: .leading)
				}
				
			}
			Spacer()
		}
	}
	
	var groupQuoteMessageView: some View {
		HStack {
			VStack(alignment: .leading, spacing: Constants.messageDateSpacing) {
				HStack(spacing: 0) {
					MessageAvatarView(avatarSize: Constants.avatarSize,
									  statusSize: Constants.statusSize,
									  userName: messageViewModel.fromClientName,
									  font: commonUIConfig.fontSet.font(style: .input3),
									  image: ""
					).padding(.trailing, Constants.spacer)
					
					Text(messageViewModel.fromClientName)
						.font(commonUIConfig.fontSet.font(style: .input3))
						.foregroundColor(commonUIConfig.colorSet.grey1)
					dateCreatedView
						.padding(.leading, Constants.groupMessageDateSpacing)
					
					Spacer()
				}.padding(.top, Constants.spacer)
				
				HStack(spacing: 0) {
					Rectangle()
						.fill(commonUIConfig.colorSet.grey2)
						.frame(width: Constants.messageIndicatorWidth)
						.cornerRadius(Constants.messageIndicatorRadius)
					quoteContentView
				}.padding(.leading, Constants.groupMessageLeadingSpacing)
				
			}.frame(width: Constants.maxWidthBuble, alignment: .leading)
			Spacer()
		}
	}
	
	var dateCreatedView: some View {
		Text(messageViewModel.dateCreatedString())
			.font(commonUIConfig.fontSet.font(style: .placeholder3))
			.foregroundColor(foregroundDateText)
	}
	
	var forwardTitleView: some View {
		HStack {
			Rectangle()
				.fill(commonUIConfig.colorSet.grey2)
				.frame(width: Constants.messageIndicatorWidth, height: Constants.forwardMessageIndicatorHeight)
				.cornerRadius(Constants.messageIndicatorRadius)
			Text("\(messageViewModel.isMine ? "You" : messageViewModel.fromClientName) forwarded a message")
				.font(commonUIConfig.fontSet.font(style: .placeholder2))
				.foregroundColor(foregroundDateText)
		}
	}
	
	var quoteContentView: some View {
		VStack(alignment: .leading, spacing: 10) {
			clickableText(content: messageViewModel.getQuoteMessage(), textColor: UIColor(commonUIConfig.colorSet.grey2))
			Text(messageViewModel.getQuoteMessageName() + " " + messageViewModel.getQuoteDateString())
				.font(commonUIConfig.fontSet.font(style: .placeholder2))
				.foregroundColor(commonUIConfig.colorSet.grey3)
		}
		.padding(.vertical, 8.0)
		.padding(.horizontal, 24.0)
		.background(quoteMessageBubbleBackground)
		.clipShape(QuoteBubbleArrow(rectCorner: rectCorner))
		.onTapGesture {
			onTapQuoteMessage(messageViewModel.getQuoteMessageId())
		}
	}
	
	func messageContentView(isMine: Bool) -> some View {
		return clickableText(content: messageViewModel.isForwardedMessage ? String(messageViewModel.message.dropFirst(3)) : messageViewModel.message, textColor: UIColor(foregroundText))
			.padding(.vertical, 16.0)
			.padding(.horizontal, 24.0)
			.background(isMine ? commonUIConfig.colorSet.grey2 : commonUIConfig.colorSet.primaryDefault)
			.clipShape(BubbleArrow(rectCorner: rectCorner))
	}
	
	func clickableText(content: String, textColor: UIColor) -> some View {
		GeometryReader { geometry in
			let size = MessageTextViewContent(content: content,
											  maxSize: geometry.size,
											  textColor: textColor).intrinsicContentSize
			Group {
				if colorScheme == .light {
					MessageTextView(content: content, maxSize: geometry.size, textColor: textColor) { url in
						onTapLink(url)
					}
				} else {
					MessageTextView(content: content, maxSize: geometry.size, textColor: textColor) { url in
						onTapLink(url)
					}
				}
			}.preference(key: ContentSizeThatFitsKey.self, value: size)
		}
		.onPreferenceChange(ContentSizeThatFitsKey.self) {
			contentSizeThatFits = $0
		}
		.frame(
			maxWidth: self.contentSizeThatFits.width,
			minHeight: self.contentSizeThatFits.height,
			maxHeight: self.contentSizeThatFits.height,
			alignment: .leading
		)
	}
	
	func imageContentView(isMine: Bool) -> some View {
		return VStack(alignment: messageViewModel.isMine ? .trailing : .leading, spacing: 0) {
			MessageImageView(listImageURL: MessageUtils.getImageUriStrings(content: messageViewModel.message), fromClientName: messageViewModel.fromClientName)
			if let message = MessageUtils.getImageMessageContent(content: messageViewModel.message) {
				Text(message)
					.font(commonUIConfig.fontSet.font(style: .input2))
					.lineSpacing(10)
					.padding(.horizontal, 24)
					.padding(.bottom, 16)
					.foregroundColor(foregroundText)
			}
		}
		.background(isMine ? commonUIConfig.colorSet.grey2 : commonUIConfig.colorSet.primaryDefault)
		.clipShape(BubbleArrow(rectCorner: rectCorner))
	}
	
	func fileContentView(isMine: Bool) -> some View {
		let listFileUrl = MessageUtils.getFileUriStrings(content: messageViewModel.message)
		return VStack(alignment: .leading, spacing: 16) {
			ForEach(listFileUrl, id: \.self) { fileUrl in
				VStack(alignment: .leading, spacing: 6) {
					HStack(spacing: 6) {
						commonUIConfig.imageSet.downloadIcon
							.foregroundColor(foregroundText)
						Text(MessageUtils.getFileNameFromUrl(url: fileUrl))
							.font(commonUIConfig.fontSet.font(style: .input2))
							.foregroundColor(foregroundText)
					}
					Text(MessageUtils.getFileSizeInMegabytesString(url: fileUrl))
						.font(commonUIConfig.fontSet.font(style: .placeholder3))
						.foregroundColor(fileSizeForeground)
				}.onTapGesture {
					onTapFile(fileUrl)
				}
			}
		}.padding(.horizontal, 24)
			.padding(.vertical, 16)
			.background(isMine ? commonUIConfig.colorSet.grey2 : commonUIConfig.colorSet.primaryDefault)
			.clipShape(BubbleArrow(rectCorner: rectCorner))
	}
}

// MARK: - Private function
private extension MessageBubbleView {
	
	private var foregroundText: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey5 : commonUIConfig.colorSet.greyLight2
	}
	
	private var foregroundDateText: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey3 : commonUIConfig.colorSet.greyLight
	}
	
	private var quoteMessageBubbleBackground: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey5 : commonUIConfig.colorSet.greyLight
	}
	
	private var fileSizeForeground: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey4 : commonUIConfig.colorSet.greyLight
	}
}

struct ContentSizeThatFitsKey: PreferenceKey {
	static var defaultValue: CGSize = .zero

	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
		value = nextValue()
	}
}
