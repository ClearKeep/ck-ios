//
//  RegisterView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import CommonUI

private enum Constants {
	static let widthReView = UIScreen.main.bounds.width - 20
	static let spacer = 50.0
	static let heightLogo = 120.0
	static let widthLogo = 160.0
	static let spacing = 20.0
}

struct RegisterView: View {
// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme

// MARK: - Body
	var body: some View {
		ZStack {
			ScrollView {
				Spacer(minLength: Constants.spacer)
				VStack(spacing: Constants.spacing) {
					imageLogo
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.widthLogo, height: Constants.heightLogo)
					RegisterContentView(username: "Test", password: "123", displayname: "Minh", rePassword: "123", inputStyle: .normal)
						.frame(width: Constants.widthReView)
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
	}
}
// MARK: - Private func
private extension RegisterView {
	var imageLogo: Image {
		AppTheme.shared.imageSet.logo
	}

	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}
	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .leading, endPoint: .trailing)
	}
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}
// MARK: - Preview
struct RegisterView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterView()
	}
}
