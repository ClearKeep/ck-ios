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
}

struct RegisterView: View {
// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@State var appTheme: AppTheme

// MARK: - Body
	var body: some View {
		ZStack {
			ScrollView {
				Spacer(minLength: Constants.spacer)
				VStack(spacing: 20) {
					appTheme.imageSet.logo
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.widthLogo, height: Constants.heightLogo)
					RegisterContentView(username: "Test", password: "123", displayname: "Minh", rePassword: "123", appTheme: .shared, inputStyle: .normal)
						.frame(width: Constants.widthReView)
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(colorScheme == .light ? appTheme.colorSet.primaryDefault : appTheme.colorSet.black)
		.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
	}
}

// MARK: - Preview
struct RegisterView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterView( appTheme: .shared)
	}
}
