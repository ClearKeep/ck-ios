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
	static let sizeImage = 64.0
}

struct SearchMessageView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isMessageChat: Bool = false
	@State private var model: [SearchModels] = [SearchModels(id: 1, imageUser: AppTheme.shared.imageSet.faceIcon, userName: "Alex Mendes", message: "... this CLK is ready for tes...", groupText: "CLK - System architecture", dateMessage: "Today at 1:55 PM CLK Group"),
												SearchModels(id: 2, imageUser: AppTheme.shared.imageSet.faceIcon, userName: "Alex Mendes", message: "... this CLK is ready for tes...", groupText: "CLK - System architecture", dateMessage: "Today at 1:55 PM CLK Group"),
												SearchModels(id: 3, imageUser: AppTheme.shared.imageSet.faceIcon, userName: "Alex Mendes", message: "... this CLK is ready for tes...", groupText: "CLK - System architecture", dateMessage: "Today at 1:55 PM CLK Group")]
	// MARK: - Body
	var body: some View {
		ForEach(0..<model.count, id: \.self) { index in
			VStack(alignment: .leading, spacing: Constants.spacing) {
				NavigationLink(
					destination: EmptyView(),
					isActive: $isMessageChat,
					label: {
						HStack(spacing: Constants.spacing) {
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
			}.background(backgroundColorView)
		}
	}
}
	// MARK: - Private Variables
private extension SearchMessageView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
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

	// MARK: - Preview
#if DEBUG
struct SearchMessageView_Previews: PreviewProvider {
	static var previews: some View {
		SearchMessageView()
	}
}
#endif
