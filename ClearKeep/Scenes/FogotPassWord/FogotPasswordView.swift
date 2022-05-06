//
//  FogotPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let imageScale = 40.0
}

struct FogotPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Body
	var body: some View {
		content
			.hideKeyboardOnTapped()
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "AdvancedServer.SeverSetting".localized,
										  titleColor: foregroundBackButton,
										  backgroundColors: colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary : AppTheme.shared.colorSet.gradientBlack,
										  leftBarItems: {
				buttonBack
			},
										  rightBarItems: {
				Spacer()
			})
			.background(backgroundColorView)
	}
}

// MARK: - Private
private extension FogotPasswordView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension FogotPasswordView {
	var notRequestedView: some View {
		FogotPasswordContentView(emailStyle: .default)
	}

	var buttonBack : some View {
		Button(action: customBack) {
			AppTheme.shared.imageSet.backIcon
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: Constants.imageScale, height: Constants.imageScale)
				.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Private variable
private extension FogotPasswordView {
	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}
// MARK: - Private func
private extension FogotPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView()
	}
}
#endif
