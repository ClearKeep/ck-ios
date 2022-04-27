//
//  AddServerView.swift
//  ClearKeep
//
//  Created by MinhDev on 26/04/2022.
//
import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let paddingLeading = 90.0
	static let padding = 5.0
	static let radius = 40.0
	static let paddingTrailling = 17.0
	static let paddingTop = 21.0
	static let spacing = 12.0
}

struct AddServerView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var serverText: String = ""
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var showingLogin: Bool = false
	@State private(set) var disableButton: Bool = true

	// MARK: - Init
	init(inputStyle: TextInputStyle = .default) {
		self._inputStyle = .init(initialValue: inputStyle)
	}

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.padding) {
			Text("JoinServer.Body".localized)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(foregroundColorTitle)
			VStack(spacing: Constants.spacing) {
				CommonTextField(text: $serverText,
								inputStyle: $inputStyle,
								placeHolder: "JoinServer.Placehoder".localized,
								onEditingChanged: { edit in
					if edit {
						buttonStatus()
					} else {
						buttonStatus()
					}
				})

				Button(action: {
					hideKeyboard()
					self.presentationMode.wrappedValue.dismiss()
				}, label: {
					Text("JoinServer.TitleButton".localized)
						.frame(maxWidth: .infinity, alignment: .center)
						.padding(.all, Constants.padding)
						.background(backgroundColorButton)
						.foregroundColor(AppTheme.shared.colorSet.background)
				})
					.disabled(disableButton == true)
					.cornerRadius(Constants.radius)
					.padding(.trailing, Constants.paddingTrailling)
				Text("JoinServer.TipTitle".localized)
					.font(AppTheme.shared.fontSet.font(style: .input3))
					.foregroundColor(foregroundColorTips)
			}
			.padding(.trailing, Constants.paddingTrailling)
			.padding(.top, Constants.paddingTop)
		}
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.modifier(NavigationModifier())
	}
}

// MARK: - Private variable
private extension AddServerView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var backgroundColorButton: LinearGradient {
		disableButton ? backgroundColorUnActive : backgroundColorActive
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorUnActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorTips: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.primaryDefault
	}

}

// MARK: - Private func
private extension AddServerView {
	func buttonStatus() {
		serverText == "" ? (disableButton = false) : (disableButton = true)
	}
}

// MARK: - Preview
#if DEBUG
struct AddServerView_Previews: PreviewProvider {
	static var previews: some View {
		AddServerView()
	}
}
#endif
