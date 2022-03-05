//
//  RegisterView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import CommonUI

private enum Constants {
	static let width = 315.0
	static let height = 500.0
	static let radius = 32.0
}

struct RegisterView: View {
	@State var imageIcon: IAppImageSet = AppImageSet()
	var bgm: IColorSet = ColorSet()
	var body: some View {
		ScrollView {
			imageIcon.logo
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 200, alignment: .center)

			RegisterContentView(username: "Test", password: "123", displayname: "Minh", rePassword: "123", inputStyle: .normal)
		}
		.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
		.background(bgm.primaryLight)
	}

}

struct RegisterView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterView()
	}
}
