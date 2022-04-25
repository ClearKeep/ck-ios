//
//  SearchAllView.swift
//  ClearKeep
//
//  Created by MinhDev on 05/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let heightCatalog = 28.0
}

struct SearchAllView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				Text("Search.People".localized.uppercased())
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchUserView()
				Text("Search.GroupChat".localized.uppercased())
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchGroupView()
				Text("Search.Message".localized.uppercased())
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchMessageView()
				Spacer()
			}
		}
		.background(backgroundColorView)
		.padding(.horizontal, Constants.spacing)
	}
}

	// MARK: - Private variable
private extension SearchAllView {
	
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}
	
	var backgroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}
}

	// MARK: - Preview
#if DEBUG
struct SearchAllView_Previews: PreviewProvider {
	static var previews: some View {
		SearchAllView()
	}
}
#endif
