//
//  MessageTextField.swift
//  CommonUI
//
//  Created by Quang Pham on 25/04/2022.
//

import SwiftUI
import UIKit

private enum Constants {
	static let focusBorderWidth = 2.0
	static let unfocusBorderWidth = 0.0
	static let radius = 16.0
	static let maxHeight = 110.0
	static let horizontalPadding = 24.0
	static let verticalPadding = 19.0
}

struct MessageTextField: UIViewRepresentable {
	
	let colorScheme: ColorScheme
	let placeholder: String
	
	@Binding var text: String
	@Binding var height: CGFloat
	@Binding var isEditing: Bool
	@Binding var isReplying: Bool
				
	private let textView = UITextView()
	private let placeholderLabel = UILabel()
	
	private var textContainerInset: UIEdgeInsets {
		.init(top: Constants.verticalPadding, left: Constants.horizontalPadding, bottom: Constants.verticalPadding, right: Constants.horizontalPadding)
	}
	
	private var textColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.black : commonUIConfig.colorSet.greyLight
	}
	
	private var backgroundColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey5 : commonUIConfig.colorSet.darkGrey2
	}
	
	func makeUIView(context: Context) -> UITextView {
		let textField = textView
		textField.delegate = context.coordinator
		
		placeholderLabel.text = placeholder
		placeholderLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		placeholderLabel.sizeToFit()
		textField.addSubview(placeholderLabel)
		placeholderLabel.textColor = UIColor.lightGray
		placeholderLabel.isHidden = !textField.text.isEmpty
		
		placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
		let verticalConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
		let leftConstraint = placeholderLabel.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 28)
		textField.addConstraints([verticalConstraint, leftConstraint])
		
		placeholderLabel.isHidden = !text.isEmpty
		
		textField.isEditable = true
		textField.isSelectable = true
		textField.isUserInteractionEnabled = true
		textField.showsVerticalScrollIndicator = false
		textField.isScrollEnabled = true
		
		textField.layer.cornerRadius = CGFloat(Constants.radius)
		textField.textContainerInset = textContainerInset
		textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		
		textField.backgroundColor = UIColor(backgroundColor)
		textField.textColor = UIColor(textColor)
		textField.tintColor = UIColor(textColor)
		textField.layer.borderColor = UIColor(textColor).cgColor
		textField.text = text
		return textField
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		if !isEditing && isReplying {
			uiView.becomeFirstResponder()
		}
		if uiView.text != text {
			if text.isEmpty {
				uiView.text = ""
				uiView.delegate?.textViewDidChange?(uiView)
			}
		}
		
		calculateHeight(view: uiView)
	}
	
	private func calculateHeight(
		view: UIView
	) {
		let size = view.sizeThatFits(
			CGSize(
				width: view.frame.size.width,
				height: CGFloat.greatestFiniteMagnitude
			)
		)
		
		guard height != size.height else { return }
		DispatchQueue.main.async {
			height = min(size.height, Constants.maxHeight)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	final class Coordinator: NSObject, UITextViewDelegate {
		let parent: MessageTextField
		
		init(parent: MessageTextField) {
			self.parent = parent
		}
		
		func textViewDidChange(_ uiView: UITextView) {
			if !parent.isEditing {
				parent.isEditing = true
			}
			
			parent.text = uiView.text
			parent.placeholderLabel.isHidden = !uiView.text.isEmpty
		}
		
		func textViewDidBeginEditing(_: UITextView) {
			parent.isEditing = true
			parent.textView.layer.borderWidth = Constants.focusBorderWidth
		}
		
		func textViewDidEndEditing(_: UITextView) {
			parent.isEditing = false
			parent.textView.layer.borderWidth = Constants.unfocusBorderWidth
		}
	}
}
