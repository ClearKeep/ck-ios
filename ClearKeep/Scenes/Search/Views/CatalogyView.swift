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
	static let spacing = 9.0
	static let spacingHstack = 2.0
	static let paddingHorizontal = 19.0
	static let paddingVertical = 2.0
	static let radius = 8.0
	static let heightButton = 28.0
	static let widthButton = 78.0
}

struct CatalogyView<T: ISearchCatalogy>: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	let states: [T]
	@Binding var selectedState: T
	@State private(set) var selected: String?
	
	// MARK: - Body
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: Constants.spacingHstack) {
				ForEach(0..<states.count, id: \.self) { index in
					Button {
						selectedState = states[index]
						self.selected = states[index].title
					} label: {
						Text(states[index].title)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(colorScheme == .light ? (self.selected == states[index].title ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.grey2) : AppTheme.shared.colorSet.background)
					}
					.frame(width: Constants.widthButton, height: Constants.heightButton)
					.background(backgroundButton)
					.cornerRadius(Constants.radius)
					.overlay(
						RoundedRectangle(cornerRadius: Constants.radius)
							.stroke(self.selected == states[index].title ?  AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault, lineWidth: lineWidth)
					)
					Spacer(minLength: Constants.spacingHstack)
				}
			}
			.fixedSize()
			.padding(.horizontal, Constants.spacing)
		}
		.background(backgroundColorView)
		.frame(maxWidth: .infinity)
	}
}

// MARK: - Private Variables
private extension CatalogyView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
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
	
	var lineWidth: CGFloat {
		colorScheme == .light ? 0 : 1
	}
}
