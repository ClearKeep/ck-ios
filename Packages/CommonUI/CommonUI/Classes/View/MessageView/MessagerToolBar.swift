//
//  MessagerToolBar.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI

private enum Constants {
	static let spacingHorizontal = 15.0
	static let cornerRadius = 16.0
}

struct MessagerToolBar: View {
	// MARK: - Variables
	var sendAction: (String) -> Void
	var sharePhoto: () -> Void
	
	// MARK: - State
	@State private var messageText: String = ""
	
	// MARK: - Body
	var body: some View {
		HStack(spacing: Constants.spacingHorizontal) {
			Button {
				sharePhoto()
			} label: {
				Image("ic_photo")
					.foregroundColor(commonUIConfig.colorSet.grey1)
			}
			Button {} label: {
				Image("ic_tag")
					.foregroundColor(commonUIConfig.colorSet.grey1)
			}
			
			MultilineTextField(placeholder: "Message.Input.PlaceHolder".localized, text: $messageText)
				.padding(.vertical, 4)
				.padding(.horizontal)
				.background(commonUIConfig.colorSet.grey5)
				.cornerRadius(Constants.cornerRadius)
				.clipped()
			
			// Send Button...
			Button(action: {
				// appeding message...
				// adding animation...
				withAnimation(.easeIn) {
					sendAction(messageText)
				}
				messageText = ""
			}, label: {
				Image("ic_sent")
					.foregroundColor(commonUIConfig.colorSet.primaryDefault)
			})
		}
		.padding(.horizontal)
		.padding(.bottom, 8)
		.animation(.easeOut)
	}
}
