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
	@State private var editing = false
	
    var body: some View {
		VStack {
			TextField("Email", text: $email, onEditingChanged: { edit in
				self.editing = edit
			   })
				.modifier(NormalTextField(mode: .light, focused: $editing))

			TextField("Password", text: $password, onCommit: { editing = false})
				.onTapGesture {
					editing = true
				}
				.modifier(PasswordTextField(mode: .error, focused: $editing))
			}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
		LoginView()
    }
}
