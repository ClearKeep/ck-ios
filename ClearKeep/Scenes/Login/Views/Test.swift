//
//  Test.swift
//  ClearKeep
//
//  Created by MinhDev on 06/03/2022.
//

import SwiftUI

struct Test: View {
	var body: some View {
		NavigationView{
			NavigationLink(destination: FogotPasswordView(email: "minhdn1@vmodev.com", appTheme: .shared, inputStyle: .normal)) {
				Text("sadsd")
			}
		}
	}
}

struct Test_Previews: PreviewProvider {
	static var previews: some View {
		Test()
	}
}
