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
	static let paddingLeading = 100.0
	static let padding = 5.0
	static let radius = 40.0
}

struct AddServerView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var serverText: String = ""
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var showingLogin: Bool = false

	// MARK: - Init
	init(inputStyle: TextInputStyle = .default) {
		self._inputStyle = .init(initialValue: inputStyle)
	}

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.padding) {
			Text("To join a server, please type in the link of the server")
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(foregroundColorTitle)
				.padding(.all, Constants.padding)
			CommonTextField(text: $serverText,
							inputStyle: $inputStyle,
							placeHolder: "DirectMessages.LinkTitle".localized,
							onEditingChanged: { _ in })
			Button("ForgotPass.Resetpassword".localized) {
				self.presentationMode.wrappedValue.dismiss()
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.all, Constants.padding)
			.background(backgroundColorButton)
			.foregroundColor(AppTheme.shared.colorSet.background)
			.cornerRadius(Constants.radius)
			Text("Tips: Ask your server admin to get the url to the server")
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(foregroundColorTips)
		}
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.navigationBarTitle("")
		.navigationBarHidden(true)
	}
}

// MARK: - Private variable
private extension AddServerView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.black
	}

	var backgroundColorButton: LinearGradient {
		backgroundColorGradient
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
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
	func menuAction() {

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
