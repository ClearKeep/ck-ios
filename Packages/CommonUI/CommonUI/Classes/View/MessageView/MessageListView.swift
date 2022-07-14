//
//  MessageListView.swift
//  ClearKeep
//
//  Created by Nguyễn Nam on 5/24/21.
//

import SwiftUI

public struct MessageListView: View {
	
	// MARK: - Variables
	private var listMessages: [IMessageViewModel] = []
	
	@Binding private var hasReachedTop: Bool
	@Binding private var isShowLoading: Bool
	@Binding private var showScrollToLatestButton: Bool
	@Binding private var scrollToLastest: Bool

	@State private var scrollOffset: CGFloat = 0
	
	var onLongPress: (IMessageViewModel) -> Void
	
	// MARK: - Constants
	private let scrollAreaId = "scrollArea"
	
	// MARK: - Init
	public init(messages: [IMessageViewModel],
				hasReachedTop: Binding<Bool>,
				isShowLoading: Binding<Bool>,
				showScrollToLatestButton: Binding<Bool>,
				scrollToLastest: Binding<Bool>,
				onLongPress: @escaping (IMessageViewModel) -> Void) {
		self.listMessages = messages
		self._hasReachedTop = hasReachedTop
		self._isShowLoading = isShowLoading
		self._showScrollToLatestButton = showScrollToLatestButton
		self._scrollToLastest = scrollToLastest
		self.onLongPress = onLongPress
	}
	
	public var body: some View {
		GeometryReader { contentsGeometry in
			ScrollViewReader { scrollView in
				ScrollView {
					GeometryReader { proxy in
						let frame = proxy.frame(in: .named(scrollAreaId))
						let offset = frame.minY
						let width = frame.width
						Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
					}
					LazyVStack(spacing: 0) {
						let listDisplayMessage = MessageUtils.getListRectCorner(messages: listMessages)
						ForEach(listDisplayMessage, id: \.message.id) { message in
							let messageDate: String? = MessageUtils.showMessageDate(for: message, in: listDisplayMessage)
							MessageBubbleView(messageViewModel: message.message, rectCorner: message.rectCorner)
								.onTapGesture { }
								.onLongPressGesture(perform: { onLongPress(message.message) })
								.overlay(
									messageDate != nil ?
									VStack {
										Text(messageDate ?? "")
											.font(commonUIConfig.fontSet.font(style: .body3))
											.foregroundColor(commonUIConfig.colorSet.grey3)
											.offset(y: -30)
										Spacer()
									} : nil
								)
								.padding(.top, messageDate != nil ? 60 : 8)
								.flippedUpsideDown()
						}
					}
					.padding(.horizontal)
					GeometryReader { topViewGeometry in
						let frame = topViewGeometry.frame(in: .global)
						let isVisible = contentsGeometry.frame(in: .global).contains(CGPoint(x: frame.midX, y: frame.midY))

						HStack {
							Spacer()
							ProgressView().progressViewStyle(CircularProgressViewStyle())
							Spacer()
						}.opacity(isShowLoading ? 0 : 1)
						.preference(key: IsVisiblePreferenceKey.self, value: isVisible)
					}
					.frame(height: 20)
					.onPreferenceChange(IsVisiblePreferenceKey.self) {
						hasReachedTop = $0
					}
				}.coordinateSpace(name: scrollAreaId)
					.onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
						DispatchQueue.main.async {
							let offsetValue = value ?? 0
							let diff = offsetValue - scrollOffset
							scrollOffset = offsetValue
							let scrollButtonShown = offsetValue < -20
							if scrollButtonShown != showScrollToLatestButton {
								showScrollToLatestButton = scrollButtonShown
							}
						}
					}
				.flippedUpsideDown()
				.onChange(of: scrollToLastest) { _ in
					withAnimation {
						scrollView.scrollTo(listMessages.first?.id, anchor: .bottom)
					}
				}
			}
		}
	}
}

struct IsVisiblePreferenceKey: PreferenceKey {
	static var defaultValue: Bool = false

	static func reduce(value: inout Bool, nextValue: () -> Bool) {
		value = nextValue()
	}
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat?
	
	static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
		value = value ?? nextValue()
	}
}
