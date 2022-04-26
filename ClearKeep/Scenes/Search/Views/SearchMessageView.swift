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
	static let spacing = 5.0
	static let spacingHstack = 16.0
	static let sizeImage = 64.0
	static let paddingTop = 28.0
	static let leading = 16.0
	static let paddingVstack = 22.0
}

struct SearchMessageView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isMessageChat: Bool = false
	@State private var model: [SearchModels] = []
	// MARK: - Body
	var body: some View {
		ForEach(0..<model.count, id: \.self) { index in
			VStack(alignment: .leading, spacing: Constants.paddingVstack) {
				NavigationLink(
					destination: EmptyView(),
					isActive: $isMessageChat,
					label: {
						HStack(spacing: Constants.spacingHstack) {
							model[index].imageUser
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: Constants.sizeImage, height: Constants.sizeImage)
								.clipShape(Circle())
							VStack(alignment: .leading, spacing: Constants.spacing) {
								Text(model[index].userName)
									.font(AppTheme.shared.fontSet.font(style: .body2))
									.foregroundColor(foregroundColorUserName)
								Text(model[index].message)
									.font(AppTheme.shared.fontSet.font(style: .input3))
									.foregroundColor(foregroundColorUserName)
									.frame(alignment: .center)
								HStack {
									Text(model[index].dateMessage)
										.font(AppTheme.shared.fontSet.font(style: .input3))
										.foregroundColor(foregroundColorUserName)
									Text(model[index].groupText)
										.font(AppTheme.shared.fontSet.font(style: .input3))
										.foregroundColor(foregroundColorUserName)
								}
							}
							Spacer()
						}
					})
			}
			.background(backgroundColorView)
			.padding(.top, Constants.paddingTop)
			.padding(.leading, Constants.leading)
		}
	}
}
// MARK: - Private Variables
private extension SearchMessageView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.greyLight2 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Preview
#if DEBUG
struct SearchMessageView_Previews: PreviewProvider {
	static var previews: some View {
		SearchMessageView()
	}
}
#endif
