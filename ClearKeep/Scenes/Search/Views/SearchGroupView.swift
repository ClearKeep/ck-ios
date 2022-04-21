//
//  SearchGroupView.swift
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

struct SearchGroupView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var groupText: String
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.spacing)
	}
}

// MARK: - Private
private extension SearchGroupView {
	var content: AnyView {
		AnyView(groupView)
	}
}

// MARK: - Private Variables
private extension SearchGroupView {
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private func
private extension SearchGroupView {
	func action() {
		
	}
}

// MARK: - Loading Content
private extension SearchGroupView {
	var groupView: some View {
		VStack(alignment: .leading) {
			Button(action: action) {
				Text(groupText)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundColorText)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
					.padding(.all, Constants.spacing)
			}
		}
	}
}

// MARK: - Interactor
private extension SearchGroupView {
}

// MARK: - Preview
#if DEBUG

struct SearchGroupView_Previews: PreviewProvider {
	static var previews: some View {
		SearchGroupView(groupText: .constant(""))
	}
}
#endif
