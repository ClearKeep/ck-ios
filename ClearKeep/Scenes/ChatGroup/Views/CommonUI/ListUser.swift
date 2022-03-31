//
//  ListUser.swift
//  ClearKeep
//
//  Created by đông on 30/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constant {
	static let sizeImage = 64.0
}

struct ListUser: View {
	@State private(set) var isSelectedUser: Bool = false

	var body: some View {
		HStack {
			ZStack {
				AppTheme.shared.imageSet.splashLogo
				AppTheme.shared.imageSet.userIcon
			}
			.frame(width: Constant.sizeImage, height: Constant.sizeImage)
			.clipShape(Circle())
			//			.background(Color.green)
			Text("Alissa Baker".localized)
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
			CheckBoxButtons(text: "", isChecked: $isSelectedUser)
		}
	}
}

struct ListUser_Previews: PreviewProvider {
    static var previews: some View {
        ListUser()
    }
}
