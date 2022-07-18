//
//  MessagerToolBar.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI

private enum Constants {
	static let spacingHorizontal = 15.0
	static let padding = 19.0
	static let defaultHeight = 52.0
}

public struct MessagerToolBar: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	private let placeholder: String
	public var sendAction: (String) -> Void
	public var sharePhoto: () -> Void
	public var shareFile: () -> Void

	// MARK: - State
	@Binding private var messageText: String
	@Binding private var isReplying: Bool
	@State private var height: CGFloat = Constants.defaultHeight
	@State private var isEditing = false
	
	// MARK: - Init
	public init(message: Binding<String>,
				isReplying: Binding<Bool>,
				placeholder: String = "",
				sendAction: @escaping (String) -> Void,
				sharePhoto: @escaping () -> Void,
				shareFile: @escaping () -> Void) {
		self.placeholder = placeholder
		self.sendAction = sendAction
		self.sharePhoto = sharePhoto
		self.shareFile = shareFile
		self._isReplying = isReplying
		self._messageText = message
	}
	
	private var buttonColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey1 : commonUIConfig.colorSet.primaryDefault
	}
	
	// MARK: - Body
	public var body: some View {
		HStack(alignment: .bottom, spacing: Constants.spacingHorizontal) {
			if isEditing {
				collapseButtonView
			} else {
				expandedButtonView
			}
			
			Group {
				if colorScheme == .light {
					MessageTextField(colorScheme: .light, placeholder: placeholder, text: $messageText, height: $height, isEditing: $isEditing, isReplying: $isReplying)
				} else {
					MessageTextField(colorScheme: .dark, placeholder: placeholder, text: $messageText, height: $height, isEditing: $isEditing, isReplying: $isReplying)
				}
			}.frame(height: height)
			
			// Send Button...
			Button(action: {
				withAnimation(.easeIn) {
					sendAction(messageText)
				}
				messageText = ""
			}, label: {
				commonUIConfig.imageSet.sendIcon
					.foregroundColor(commonUIConfig.colorSet.primaryDefault)
			}).padding(.bottom, Constants.padding)
		}
		.padding(.bottom, 8)
		.animation(.easeIn(duration: 0.2))
	}
	
	private var expandedButtonView: some View {
		return HStack {
			Button {
				sharePhoto()
			} label: {
				commonUIConfig.imageSet.photoIcon
					.foregroundColor(buttonColor)
			}
			Button {
				shareFile()
			} label: {
				commonUIConfig.imageSet.linkIcon
					.foregroundColor(buttonColor)
			}
		}.padding(.bottom, Constants.padding)
	}
	
	private var collapseButtonView: some View {
		return Button {
			isEditing.toggle()
		} label: {
			commonUIConfig.imageSet.chevRightIcon
				.foregroundColor(buttonColor)
		}.padding(.bottom, Constants.padding)
	}
	
}
