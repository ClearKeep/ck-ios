//
//  HomeHeaderView.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import SwiftUI
import CommonUI

struct HomeHeaderView: View {
	@State var searchKeyword: String
	@State var inputStyle: TextInputStyle
	
	var body: some View {
		VStack {
			HStack {
				Text("CK Development")
				Button("Menu") {
					
				}
				SearchTextField(text: $searchKeyword, inputStyle: $inputStyle, placeHolder: "Search", onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .highlighted
					} else {
						inputStyle = .normal
					}
				})
			}
		}
	}
}

struct HomeHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		HomeHeaderView(searchKeyword: "Test", inputStyle: .normal)
	}
}
