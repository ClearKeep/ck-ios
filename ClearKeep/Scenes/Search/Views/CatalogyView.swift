//
//  CatalogyView.swift
//  ClearKeep
//
//  Created by MinhDev on 06/04/2022.
//


import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let padding = 20.0
	static let sizeImage = 64.0
	static let radius = 8.0
}

struct CatalogyView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var groupText: String
	private var catalog: SearchCatalogy
	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.spacing)
	}
}

// MARK: - Private
private extension CatalogyView {
	var content: AnyView {
		AnyView(catalogyView)
	}
}

// MARK: - Private Variables
private extension CatalogyView {
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}

	var backgroundButton: LinearGradient {
		colorScheme == .light ? backgroundButtonLight : backgroundButtonDark
	}

	var backgroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Private func
private extension CatalogyView {
	func action() {

	}
}

// MARK: - Loading Content
private extension CatalogyView {
	var catalogyView: some View {
		VStack(alignment: .leading) {
			Button(action: action) {
				Text(catalog.title)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundColorButton)
					.padding(.horizontal)
					.background(backgroundButton)
					.cornerRadius(Constants.radius)
			}
		}
	}
}

// MARK: - Interactor
private extension CatalogyView {
}

// MARK: - Preview
#if DEBUG

struct CatalogyView_Previews: PreviewProvider {
	static var previews: some View {
		CatalogyView(groupText: .constant(""))
	}
}
#endif
