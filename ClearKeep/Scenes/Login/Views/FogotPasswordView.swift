//
//  FogotPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 05/03/2022.
//
import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let width = UIScreen.main.bounds.width - 20.0
	static let height = 40.0
	static let radius = 40.0
	static let spacing = 20.0
}

struct FogotPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State var email: String
	@State var inputStyle: TextInputStyle

	// MARK: - Body
	var body: some View {
		NavigationView {
			content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: btnBack)

	}
}
// MARK: - Private
private extension FogotPasswordView {

	var content: AnyView {
		AnyView(notRequestedView)
	}
	var btnBack : some View {
		Button(action: customBack) {
			HStack {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Spacer()
				Text("ForgotPass.Forgot password".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}

	var backgroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var backgroundViewColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.black
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}
// MARK: - Private Func
private extension FogotPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}
// MARK: - Loading Content
private extension FogotPasswordView {
	var notRequestedView: some View {
		VStack(spacing: Constants.spacing) {
			Spacer()
			Text("ForgotPass.Please enter your email to reset your password".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
				.padding(.all)
			CommonTextField(text: $email,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "General.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					inputStyle = .normal
				} else {
					inputStyle = .highlighted
				}
			})
				.frame(width: Constants.width)
			Button("ForgotPass.Reset password".localized) {

			}
			.padding(.all)
			.frame(width: Constants.width, height: Constants.height)
			.background(backgroundButton)
			.foregroundColor(foregroundButton)
			.cornerRadius(Constants.radius)
			Spacer()
			Spacer()
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(backgroundViewColor)
		.edgesIgnoringSafeArea(.all)

	}
}
// MARK: - Interactor
private extension FogotPasswordView {
}
// MARK: - Preview
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView(email: "", inputStyle: .normal)
	}
}
