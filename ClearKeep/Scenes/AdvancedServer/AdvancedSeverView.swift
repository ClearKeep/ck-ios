//
//  AdvancedSeverView.swift
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

struct AdvancedSeverView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	// MARK: - Body
	var body: some View {
		content
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
private extension AdvancedSeverView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Private variable
private extension AdvancedSeverView {
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
private extension AdvancedSeverView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
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

// MARK: - Loading Content
private extension AdvancedSeverView {
	var notRequestedView: some View {
		AdvancedContentView()
	}
}

// MARK: - Preview
#if DEBUG
struct AdvancedSeverView_Previews: PreviewProvider {
	static var previews: some View {
		AdvancedSeverView()
	}
}
#endif
