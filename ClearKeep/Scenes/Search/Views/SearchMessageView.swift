//
//  SearchMessageView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let padding = 20.0
	static let sizeImage = 64.0
}

struct SearchMessageView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var message: String
	@Binding var groupText: String
	@Binding var dateMessage: String
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.leading, Constants.padding)
	}
}

// MARK: - Private
private extension SearchMessageView {
	var content: AnyView {
		AnyView(userView)
	}
	
	var imageContent: AnyView {
		AnyView(imageView)
	}
	
	var textContent: AnyView {
		AnyView(textView)
	}
}

// MARK: - Private Variables
private extension SearchMessageView {
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var userImage: Image {
		AppTheme.shared.imageSet.faceIcon
	}
	
	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.greyLight2 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private func
private extension SearchUserView {
	
}

// MARK: - Loading Content
private extension SearchMessageView {
	var userView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			HStack(spacing: Constants.spacing) {
				imageContent
				textContent
				Spacer()
			}
		}
	}
	
	var imageView: some View {
		userImage
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(width: Constants.sizeImage, height: Constants.sizeImage)
			.clipShape(Circle())
	}
	
	var textView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			Text(userName)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundColorUserName)
			Text(message)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(foregroundColorUserName)
				.frame(alignment: .center)
			HStack {
				Text(dateMessage)
					.font(AppTheme.shared.fontSet.font(style: .input3))
					.foregroundColor(foregroundColorUserName)
				Text(groupText)
					.font(AppTheme.shared.fontSet.font(style: .input3))
					.foregroundColor(foregroundColorUserName)
			}
		}
	}
}

// MARK: - Interactor

// MARK: - Preview
#if DEBUG
struct SearchMessageView_Previews: PreviewProvider {
	static var previews: some View {
		SearchMessageView(imageUser: .constant(Image("")), userName: .constant(""), message: .constant(""), groupText: .constant(""), dateMessage: .constant(""))
	}
}
#endif
