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
	static let sizeImage = 64.0
	static let spacingVstack = 18.0
	static let paddingTop = 17.0
	static let paddingLeading = 16.0
}

struct SearchGroupView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isGroupChat: Bool = false
	@State private var model: [SearchModels] = []
	
	// MARK: - Body
	var body: some View {
		ForEach(0..<model.count, id: \.self) { index in
			VStack(alignment: .leading, spacing: Constants.spacingVstack) {
				NavigationLink(
					destination: EmptyView(),
					isActive: $isGroupChat,
					label: {
						Button(action: action) {
							Text(model[index].groupText)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundColorText)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					})
				Spacer()
			}
			.background(backgroundColorView)
		}
		.padding(.leading, Constants.paddingLeading)
		.padding(.top, Constants.paddingTop)
	}
}

// MARK: - Private Variables
private extension SearchGroupView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
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

// MARK: - Preview
#if DEBUG

struct SearchGroupView_Previews: PreviewProvider {
	static var previews: some View {
		SearchGroupView()
	}
}
#endif
