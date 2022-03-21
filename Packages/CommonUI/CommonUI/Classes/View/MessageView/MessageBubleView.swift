//
//  MessageBubleView.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI
import Common

private enum Constants {
	static let spacingVertical = 5.0
	static let spacingHorizontal = 10.0
	static let avatarSize = CGSize(width: 16.0, height: 16.0)
	static let statusSize = CGSize(width: 8.0, height: 8.0)
	static let maxWidthBuble = UIScreen.main.bounds.width * 0.67
}

struct MessageBubbleView: View {
	var messageViewModel: MessageViewModel
	var userName: String?
	var isGroup: Bool = false
	var isShowAvatarAndUserName: Bool = false
	var rectCorner: UIRectCorner
	
	var body: some View {
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
			Text(messageViewModel.dateCreated)
				.font(commonUIConfig.fontSet.font(style: .input2))
				.foregroundColor(commonUIConfig.colorSet.grey3)
			Spacer()
			Text(messageViewModel.message)
				.modifier(MessageTextViewModifier())
				.clipShape(BubbleArrow(rectCorner: rectCorner))
		}
	}
	
	var reciverMessageView: some View {
		HStack(alignment: .firstTextBaseline) {
			Text(messageViewModel.message)
				.modifier(MessageTextViewModifier())
				.clipShape(BubbleArrow(rectCorner: rectCorner))
			Spacer()
			Text(messageViewModel.dateCreated)
				.font(commonUIConfig.fontSet.font(style: .input3))
				.padding(.leading, 4)
				.foregroundColor(commonUIConfig.colorSet.grey3)
		}
	}
}

// MARK: - Private function
private extension MessageBubbleView {
}
