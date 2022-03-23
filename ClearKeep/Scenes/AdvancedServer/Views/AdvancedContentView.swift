//
//  AdvancerContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let radius = 40.0
	static let spacing = 20.0
	static let padding = 10.0
	static let paddingTop = 50.0
}

struct AdvancedContentView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var severUrl: String
	@State private(set) var severUrlStyle: TextInputStyle
	@State private(set) var isShowingView: Bool = false

	// MARK: - Init
	init(severUrl: String = "",
		 severUrlStyle: TextInputStyle = .default) {
		self._severUrl = .init(initialValue: severUrl)
		self._severUrlStyle = .init(initialValue: severUrlStyle)
	}

	// MARK: - Body
	var body: some View {
		content
			.background(backgroundColorView)
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension AdvancedContentView {
	var backgroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}

	var foregroundCheckmask: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}

}

// MARK: - Private Func
private extension AdvancedContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func showAction() {
		isShowingView.toggle()
	}

	var content: AnyView {
		return AnyView(severUrlView)
	}

	var checkMark: AnyView {
		return AnyView(checkMarkView)
	}
}

// MARK: - Loading Content
private extension AdvancedContentView {
	var severUrlView: some View {
		VStack(spacing: Constants.spacing) {
			buttonBack
				.padding(.top, Constants.paddingTop)
				.frame(maxWidth: .infinity, alignment: .leading)
			checkMaskButton
				.frame(maxWidth: .infinity, alignment: .leading)
			if isShowingView {
				Text("AdvancedServer.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundBackButton)
					.frame(maxWidth: .infinity, alignment: .leading)
				CommonTextField(text: $severUrl,
								inputStyle: $severUrlStyle,
								inputIcon: AppTheme.shared.imageSet.mailIcon,
								placeHolder: "AdvancedServer.ServerUrl".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					if isEditing {
						severUrlStyle = .default
					} else {
						severUrlStyle = .highlighted
					}
				})
				buttonSubmit
				Spacer()
			}
			Spacer()
		}
		.padding(.all, Constants.padding)
	}

	var buttonBack : some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacing) {
				AppTheme.shared.imageSet.backIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text("AdvancedServer.SeverSetting".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}

	var buttonSubmit: some View {
		Button("AdvancedServer.Submit".localized) {
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.all, Constants.padding)
		.background(backgroundButton)
		.foregroundColor(foregroundButton)
		.cornerRadius(Constants.radius)
	}

	var checkMaskButton: some View {
		CheckBoxButtons(text: "AdvancedServer.SeverButton".localized, isChecked: $isShowingView)
			.foregroundColor(foregroundCheckmask)
	}

	var checkMarkView: some View {
		VStack {
			checkMaskButton
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.top, Constants.paddingTop)
			Spacer()
		}
		.padding(.all, Constants.padding)
	}
}

// MARK: - Interactor

// MARK: - Preview
#if DEBUG
struct AdvancedContentView_Previews: PreviewProvider {
	static var previews: some View {
		AdvancedContentView(severUrl: "", severUrlStyle: (.default))
	}
}
#endif