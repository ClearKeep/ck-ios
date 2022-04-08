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
	static let heightButton = 30.0
	static let boder = 2.0
}

struct CatalogyView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var catalog: [CatalogySelection]

	// MARK: - Initz
	init(catalog: [CatalogySelection]) {
		self._catalog = .init(initialValue: catalog)
	}

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

	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorSelect: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.greyLight2
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
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
				ForEach(0..<catalog.count, id: \.self) { index in
					item(for: catalog[index].title, action: catalog[index].action)
				}
			}
		}
	}

	private func item(for text: String, action: @escaping () -> Void) -> some View {
		Button(action: action, label: {
			Text(text)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.foregroundColor(foregroundColorText)
		})
			.padding(.horizontal)
			.frame(height: Constants.heightButton)
			.background(backgroundButton)
			.cornerRadius(Constants.radius)

	}
}

// MARK: - Interactor
private extension CatalogyView {
}
