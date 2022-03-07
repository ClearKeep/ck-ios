//
//  NewPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 06/03/2022.
//
import SwiftUI
import CommonUI

private enum Constants {
	static let width = UIScreen.main.bounds.width - 20.0
	static let height = 40.0
	static let radius = 40.0
}

struct NewPasswordView: View {
// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State var email: String
	@State var appTheme: AppTheme
	@State var inputStyle: TextInputStyle

// MARK: - Body
	var body: some View {
		NavigationView {
			VStack(alignment: .center, spacing: 10) {
				Spacer()
				Text("Please enter your details to change password")
					.font(appTheme.fontSet.font(style: .input2))
					.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.grey3)
					.padding(.all)
				CommonTextField(text: $email, inputStyle: $inputStyle, inputIcon: appTheme.imageSet.mailIcon, placeHolder: "email", keyboardType: .default, onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .normal
					} else {
						inputStyle = .highlighted
					}
				})
					.frame(width: Constants.width)
				Button("Reset Password") {

				}
				.padding(.all)
				.frame(width: Constants.width, height: Constants.height)
				.background(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.primaryDefault)
				.foregroundColor(colorScheme == .light ? appTheme.colorSet.primaryDefault : appTheme.colorSet.offWhite)
				.cornerRadius(Constants.radius)
				Spacer()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(colorScheme == .light ? appTheme.colorSet.primaryDefault : appTheme.colorSet.black)
			.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: btnBack)
		.ignoresSafeArea(edges: .top)
		.navigationBarTitleDisplayMode(.large)
	}
}
// MARK: - Private
private extension NewPasswordView {
	var btnBack : some View {
		Button(action: customBack) {
			HStack {
				appTheme.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.grey3)
				Spacer()
				Text("Enter Your New Password")
					.padding(.all)
					.font(appTheme.fontSet.font(style: .body2))
			}
			.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.grey3)
		}
	}
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	var colorbg: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Preview
struct NewPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordView(email: "minhdn1@vmodev.com", appTheme: .shared, inputStyle: .normal)
	}
}
