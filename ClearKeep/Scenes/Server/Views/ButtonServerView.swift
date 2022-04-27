//
//  ButtonServerView.swift
//  ClearKeep
//
//  Created by MinhDev on 26/04/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacingVstack = 24.0
	static let radius = 8.0
	static let sizeCricle = 6.0
	static let radiusbutton = 4.0
	static let paddingButton = 3.0
	static let sizeButton = 22.0
	static let sizeSquare = 6.0
	static let sizeOffset = 12.0
	static let selectOn = 1.0
	static let selectOff = 0.0

}

struct ButtonServerView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var serverModels: [ServerModels] = [ServerModels(id: 1, url: "Server1", title: "Server1"),
													  ServerModels(id: 2, url: "Server2", title: "Server2"),
													  ServerModels(id: 3, url: "Server3", title: "Server3")]
	@State private(set) var selected: Int?

	// MARK: - Body
	var body: some View {
		ScrollView(.vertical, showsIndicators: false) {
			VStack(spacing: Constants.spacingVstack) {
				ForEach(0..<serverModels.count, id: \.self) { index in
					ZStack {
						Button {
							self.selected = serverModels[index].id
						} label: {
							AppTheme.shared.imageSet.logo
								.resizable()
								.aspectRatio(contentMode: .fit)
								.padding(.all, Constants.paddingButton)
						}
					}
					.frame(width: Constants.sizeButton, height: Constants.sizeButton)
					.background(self.selected == serverModels[index].id ? backgroundColorSelect : backgroundButtonUnSelect)
					.cornerRadius(Constants.radius)
					.padding(.all, Constants.paddingButton)
					.overlay(
						RoundedRectangle(cornerRadius: Constants.radius)
							.stroke(AppTheme.shared.colorSet.black, lineWidth: self.selected == serverModels[index].id ? Constants.selectOn : Constants.selectOff)
					)
					Circle()
						.frame(width: self.selected == serverModels[index].id ? Constants.sizeCricle : Constants.selectOff, height: self.selected == serverModels[index].id ? Constants.sizeCricle : Constants.selectOff)
						.offset(x: Constants.sizeOffset, y: Constants.sizeOffset)
						.foregroundColor(AppTheme.shared.colorSet.primaryLight)
				}
				Button(action: addServer) {
					AppTheme.shared.imageSet.plusIcon
						.resizable()
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.padding(.all, Constants.paddingButton)
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.padding(.all, Constants.paddingButton)
				.frame(width: Constants.sizeButton, height: Constants.sizeButton)
				.background(backgroundColorLight)
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
				.cornerRadius(Constants.radiusbutton)
				.padding(.all, Constants.paddingButton)
				.overlay(
					RoundedRectangle(cornerRadius: Constants.radiusbutton)
						.stroke(AppTheme.shared.colorSet.black, lineWidth: self.selected == 0 ? Constants.selectOn : Constants.selectOff)
				)
			}
		}
	}
}

// MARK: - Private Variables
private extension ButtonServerView {
	var foregroundButtonView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight2
	}

//	var backgroundColorView: LinearGradient {
//		colorScheme == .light ? backgroundColorLight : backgroundColorDark
//	}

	var backgroundColorLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorSelect: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonUnSelect: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}
}
// MARK: - Private func
private extension ButtonServerView {
	func addServer() {
		self.selected = 0
	}
}
