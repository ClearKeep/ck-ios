//
//  MessageTextView.swift
//  CommonUI
//
//  Created by Quang Pham on 27/06/2022.
//

import SwiftUI
import UIKit

final class MessageTextViewContent: UITextView {
	var maxSize: CGSize = .zero

	// Allows SwiftUI to automatically size the label appropriately
	override var intrinsicContentSize: CGSize {
		sizeThatFits(CGSize(width: maxSize.width, height: .infinity))
	}

	convenience init(content: String, maxSize: CGSize, textColor: UIColor) {
		self.init()
		
		backgroundColor = .clear
		textContainerInset = .zero
		textContainer.lineFragmentPadding = 0
		dataDetectorTypes = .link
		isEditable = false
		isScrollEnabled = false
		linkTextAttributes = [
			.foregroundColor: textColor,
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
		let style = NSMutableParagraphStyle()
		style.lineSpacing = 10
		let attributes = [NSAttributedString.Key.paragraphStyle: style,
						  NSAttributedString.Key.foregroundColor: textColor,
						  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
		attributedText = NSAttributedString(string: content, attributes: attributes)

		self.maxSize = maxSize

		// don't resist text wrapping across multiple lines
		setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
	}
	
	// ignores all user interactions except touches on links
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if let range = characterRange(at: point),
		   !range.isEmpty,
		   let position = closestPosition(to: point, within: range),
		   let styles = textStyling(at: position, in: .forward),
		   styles[.link] != nil {
			return super.hitTest(point, with: event)
		} else {
			return nil
		}
	}
}

struct MessageTextView: UIViewRepresentable {
	
	let content: String
	let maxSize: CGSize
	let textColor: UIColor
	let onClickLink: (URL) -> Void
	
	func makeUIView(context: Context) -> MessageTextViewContent {
		let textView = MessageTextViewContent(content: content, maxSize: maxSize, textColor: textColor)
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: MessageTextViewContent, context: Context) {
		// nothing to update
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(onClickLink: onClickLink)
	}
	
	final class Coordinator: NSObject, UITextViewDelegate {

		let onClickLink: (URL) -> Void
		
		init(onClickLink: @escaping (URL) -> Void) {
			self.onClickLink = onClickLink
		}
		
		func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
			onClickLink(URL)
			return false
		}
	}
}
