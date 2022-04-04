//
//  SearchPeopleView.swift
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

struct SearchUserView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.leading, Constants.padding)
	}
}

// MARK: - Private
private extension SearchUserView {
	var content: AnyView {
		AnyView(userView)
	}
}

// MARK: - Private Variables
private extension SearchUserView {
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private func
private extension SearchUserView {
	
}

// MARK: - Loading Content
private extension SearchUserView {
	var userView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			HStack {
				imageUser
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
				Text(userName)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorUserName)
				Spacer()
			}
		}
	}
}

// MARK: - Interactor


// MARK: - Preview
#if DEBUG
struct SearchUserView_Previews: PreviewProvider {
	static var previews: some View {
		SearchUserView(imageUser: .constant(Image("")), userName: .constant(""))
	}
}
#endif
