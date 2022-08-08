//
//  MessagerBannerViewModifier.swift
//  ClearKeep
//
//  Created by Nguyễn Nam on 5/26/21.
//

import SwiftUI
import Common

private enum Constants {
	static let avatarSize = CGSize(width: 24.0, height: 24.0)
	static let statusSize = CGSize(width: 8.0, height: 8.0)
	static let timeDuration = 3.0
	static let spacing = 16.0
}

public struct MessagerBannerViewModifier: ViewModifier {
	public struct MessageData {
		var groupName: String
		var senderName: String
		var message: String
		private(set) var isGroup: Bool = false
		
		public init(senderName: String, message: String) {
			self.groupName = ""
			self.senderName = senderName
			self.message = message
			self.isGroup = false
		}
		
		public init(groupName: String, senderName: String, message: String) {
			self.groupName = groupName
			self.senderName = senderName
			self.message = message
			self.isGroup = true
		}
	}
	
	// MARK: - Variables
	@Binding var data: MessageData?
	@Binding var show: Bool
	var onTap: () -> Void
	
	// MARK: - Body
	public func body(content: Content) -> some View {
		ZStack {
			content
			if show {
				VStack {
					Group {
						if data?.isGroup ?? false {
							viewForGroup
						} else { viewForPeer }
					}
					.padding(.horizontal, 22)
					.padding(.top, 22)
					.padding(.bottom, 16)
					.background(Color.white.opacity(0.98))
					.clipShape(
						RoundedRectangle(cornerRadius: 32, style: .continuous)
					)
					.shadow(color: Color(UIColor(hex: "#111111")).opacity(0.16), radius: 24, x: 0, y: 8)
					Spacer()
				}
				.padding(.horizontal, Constants.spacing)
				.animation(.easeInOut)
				.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
				.onTapGesture {
					withAnimation {
						self.show = false
						onTap()
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
			Text(String(format: "General.Message.Banner".localized, data?.groupName ?? ""))
				.font(commonUIConfig.fontSet.font(style: .input3))
				.foregroundColor(commonUIConfig.colorSet.grey3)
				.lineLimit(1)
			HStack {
				Text("\(data?.senderName ?? ""):")
					.font(commonUIConfig.fontSet.font(style: .body2))
					.foregroundColor(commonUIConfig.colorSet.grey2)
					.lineLimit(1)
				Text(data?.message ?? "")
					.font(commonUIConfig.fontSet.font(style: .input2))
					.foregroundColor(commonUIConfig.colorSet.grey1)
					.lineLimit(1)
				Spacer()
			}
		}
	}
	
	var viewForPeer: some View {
		HStack {
			VStack(alignment: .leading, spacing: 8) {
				Text(String(format: "General.Message.Banner".localized, data?.senderName ?? ""))
					.font(commonUIConfig.fontSet.font(style: .input3))
					.foregroundColor(commonUIConfig.colorSet.grey3)
					.lineLimit(1)
				Text(data?.message ?? "Where are you? Pick up the phone please")
					.font(commonUIConfig.fontSet.font(style: .input2))
					.foregroundColor(commonUIConfig.colorSet.grey1)
					.lineLimit(1)
			}
			Spacer()
		}
	}
}

public extension View {
	func messagerBannerModifier(data: Binding<MessagerBannerViewModifier.MessageData?>, show: Binding<Bool>, onTap: @escaping (() -> Void)) -> some View {
		self.modifier(MessagerBannerViewModifier(data: data, show: show, onTap: onTap))
	}
}
