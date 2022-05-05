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
	static let spacingVertical = 5.0
	static let spacingHorizontal = 10.0
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
		HStack(alignment: .top, spacing: Constants.spacingHorizontal) {
			if messageViewModel.isMine {
				VStack(spacing: Constants.spacingVertical) {
					senderMessageView
				}
			} else {
				if isGroup {
					VStack(alignment: .leading) {
						if isShowAvatarAndUserName {
							HStack {
								MessageAvatarView(avatarSize: Constants.avatarSize,
												  statusSize: Constants.statusSize,
												  userName: messageViewModel.fromClientName,
												  font: commonUIConfig.fontSet.font(style: .input3))
								Text(messageViewModel.fromClientName)
									.font(commonUIConfig.fontSet.font(style: .input3))
									.foregroundColor(commonUIConfig.colorSet.grey1)
									.padding(.leading, 8)
								Spacer()
							}
						}
						reciverMessageView
					}
				} else {
					VStack(spacing: Constants.spacingVertical) {
						reciverMessageView
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
				Text(messageViewModel.dateCreated)
					.font(commonUIConfig.fontSet.font(style: .placeholder3))
					.foregroundColor(foregroundDateText)
				Text(messageViewModel.message)
					.modifier(MessageTextViewModifier())
					.background(commonUIConfig.colorSet.grey2)
					.clipShape(BubbleArrow(rectCorner: rectCorner))
					.foregroundColor(foregroundText)
			}.frame(width: Constants.maxWidthBuble, alignment: .trailing)
		}
		
	}
	
	var reciverMessageView: some View {
		HStack {
			VStack(alignment: .leading, spacing: Constants.messageDateSpacing) {
				Text(messageViewModel.dateCreated)
					.font(commonUIConfig.fontSet.font(style: .placeholder3))
					.foregroundColor(foregroundDateText)
				Text(messageViewModel.message)
					.modifier(MessageTextViewModifier())
					.background(commonUIConfig.colorSet.primaryDefault)
					.clipShape(BubbleArrow(rectCorner: rectCorner))
					.foregroundColor(foregroundText)
			}.frame(width: Constants.maxWidthBuble, alignment: .leading)
			Spacer()
		}
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
}
