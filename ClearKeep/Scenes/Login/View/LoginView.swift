//
//  LoginView.swift
//  ClearKeep
//
//  Created by đông on 02/03/2022.
//

import SwiftUI

struct LoginView: View {
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var editingEmail = false
	@State private var editingPassword = false
	private var image: IAppImageSet = AppImageSet()
	
    var body: some View {
		VStack {
			TextField("Email", text: $email, onEditingChanged: { edit in
				self.editingEmail = edit
			   })
				.modifier(NormalTextField(image: image.mailIcon, focused: $editingEmail))

			TextField("Password", text: $password, onEditingChanged: { edit in
				self.editingPassword = edit
			   })
				.modifier(PasswordTextField(image: image.lockIcon, focused: $editingPassword))
			}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
		LoginView()
    }
}
