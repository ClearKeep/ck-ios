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
	
	var messageViewModel: IMessageViewModel
	var userName: String?
	var isGroup: Bool = false
	var isShowAvatarAndUserName: Bool = false
	var rectCorner: UIRectCorner
		
	public init(messageViewModel: IMessageViewModel,
				rectCorner: UIRectCorner) {
		self.messageViewModel = messageViewModel
		self.rectCorner = rectCorner
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
				
				messageContentView
					.frame(width: Constants.maxWidthBuble, alignment: .trailing)
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
				messageContentView
					.frame(width: Constants.maxWidthBuble, alignment: .leading)
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
					.background(commonUIConfig.colorSet.grey2)
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
							.foregroundColor(commonUIConfig.colorSet.grey1)
					}
					dateCreatedView
						.padding(.leading, Constants.groupMessageDateSpacing)
					
					Spacer()
				}.padding(.top, Constants.spacer)
				
				messageContentView
					.padding(.leading, Constants.groupMessageLeadingSpacing)
					.frame(width: Constants.maxWidthBuble, alignment: .leading)
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
		VStack(alignment: .trailing, spacing: 0) {
			Text(messageViewModel.getQuoteMessage())
				.modifier(MessageTextViewModifier())
				.foregroundColor(commonUIConfig.colorSet.grey2)
			Text(messageViewModel.getQuoteMessageName() + " " + messageViewModel.dateCreatedString())
				.font(commonUIConfig.fontSet.font(style: .placeholder2))
				.foregroundColor(commonUIConfig.colorSet.grey3)
				.padding(.bottom, 6)
				.padding(.leading, Constants.groupMessageLeadingSpacing)
		}
		.background(quoteMessageBubbleBackground)
			.clipShape(BubbleArrow(rectCorner: rectCorner))
	}
	
	var messageContentView: some View {
		Text(messageViewModel.isForwardedMessage ? String(messageViewModel.message.dropFirst(3)) : messageViewModel.message)
			.modifier(MessageTextViewModifier())
			.background(commonUIConfig.colorSet.grey2)
			.clipShape(BubbleArrow(rectCorner: rectCorner))
			.foregroundColor(foregroundText)
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
}
