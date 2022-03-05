//
//  FogotPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 05/03/2022.
//

import SwiftUI
import CommonUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let notifyHeight = 22.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let spacing = 14.0
}

struct FogotPasswordView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@State var appTheme: AppTheme

	// MARK: - Body
	var body: some View {
		NavigationView {

			VStack(spacing: 20) {

			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(colorScheme == .light ? appTheme.colorSet.primaryDefault : appTheme.colorSet.black)
		.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
	}
}
// MARK: - Preview
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView(appTheme: .shared)
	}
}
