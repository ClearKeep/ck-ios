//
//  MessagerBannerViewModifier.swift
//  ClearKeep
//
//  Created by Nguyễn Nam on 5/26/21.
//

// swiftlint:disable multiple_closures_with_trailing_closure

import SwiftUI
import Common

private enum Constants {
	static let avatarSize = CGSize(width: 24.0, height: 24.0)
	static let statusSize = CGSize(width: 8.0, height: 8.0)
	static let timeDuration = 3.0
	static let spacing = 16.0
}

struct MessagerBannerViewModifier: ViewModifier {
	struct MessageData {
		var groupName: String
		var senderName: String
		var userIcon: Image?
		var message: String
		private(set) var isGroup: Bool = false
		
		init(senderName: String, userIcon: Image? = nil, message: String) {
			self.groupName = ""
			self.senderName = senderName
			self.userIcon = userIcon
			self.message = message
			self.isGroup = false
		}
		
		init(groupName: String, senderName: String, userIcon: Image? = nil, message: String) {
			self.groupName = groupName
			self.senderName = senderName
			self.userIcon = userIcon
			self.message = message
			self.isGroup = true
		}
	}
	
	// MARK: - Variables
	@Binding var data: MessageData
	@Binding var show: Bool
	
	// MARK: - Body
	func body(content: Content) -> some View {
		ZStack {
			content
			if show {
				VStack {
					VStack(spacing: Constants.spacing) {
						if data.isGroup {
							viewForGroup
						} else { viewForPeer }
						HStack(spacing: Constants.spacing) {
							Button(action: {}) { Text("Message.Reply".localized) }
							Button(action: {}) { Text("Message.Mute".localized) }
							Spacer()
						}
						.font(commonUIConfig.fontSet.font(style: .input3))
						.foregroundColor(commonUIConfig.colorSet.primaryDefault)
					}
					.padding()
					.background(Color.white.opacity(0.95))
					.clipShape(
						RoundedRectangle(cornerRadius: 32, style: .continuous)
					)
					.shadow(color: commonUIConfig.colorSet.grey1, radius: 24, x: 0, y: 8)
					
					Spacer()
				}
				.padding(.top, 10)
				.padding(.vertical, Constants.spacing)
				.animation(.easeInOut)
				.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
				.onTapGesture {
					withAnimation {
						self.show = false
					}
				}.onAppear(perform: {
					DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeDuration) {
						withAnimation {
							self.show = false
						}
					}
				})
			}
		}
	}
}

private extension MessagerBannerViewModifier {
	var viewForGroup: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(String(format: "Message.Banner.Content".localized, data.groupName))
				.font(commonUIConfig.fontSet.font(style: .input3))
				.foregroundColor(commonUIConfig.colorSet.grey3)
				.lineLimit(1)
			HStack {
				avatarView
					.padding(.trailing, Constants.spacing)
				Text(data.senderName + ":")
					.font(commonUIConfig.fontSet.font(style: .input2))
					.foregroundColor(commonUIConfig.colorSet.grey1)
					.lineLimit(1)
				Text(data.message)
					.font(commonUIConfig.fontSet.font(style: .input2))
					.foregroundColor(commonUIConfig.colorSet.grey1)
					.lineLimit(1)
				Spacer()
			}
		}
	}
	var viewForPeer: some View {
		HStack(spacing: Constants.spacing) {
			avatarView
			VStack(alignment: .leading, spacing: 8) {
				Text(String(format: "Message.Banner.Content".localized, data.senderName))
					.font(commonUIConfig.fontSet.font(style: .input3))
					.foregroundColor(commonUIConfig.colorSet.grey3)
					.lineLimit(1)
				Text(data.message)
					.font(commonUIConfig.fontSet.font(style: .input2))
					.foregroundColor(commonUIConfig.colorSet.grey1)
					.lineLimit(1)
			}
			Spacer()
		}
	}
	
	var avatarView: some View {
		MessageAvatarView(avatarSize: Constants.avatarSize,
								statusSize: Constants.statusSize,
								userName: data.senderName,
								font: commonUIConfig.fontSet.font(style: .input3),
								image: data.userIcon)
	}
}

private extension View {
	func messagerBannerModifier(data: Binding<MessagerBannerViewModifier.MessageData>, show: Binding<Bool>) -> some View {
		self.modifier(MessagerBannerViewModifier(data: data, show: show))
	}
}
