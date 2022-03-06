//
//  HomeHeaderView.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct HomeHeaderView: View {
	// MARK: - Variables
	@Binding var searchText: String
	@Binding var inputStyle: TextInputStyle
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		VStack {
			HStack {
				Text("CK Development")
				Button("Menu") {
					
				}
			}
			SearchTextField(searchText: $searchText,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.searchIcon,
							placeHolder: "General.Search".localized,
							onEditingChanged: { _ in }).frame(height: 52.0)
		}
	}
}

struct HomeHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		HomeHeaderView(searchText: .constant("Test"), inputStyle: .constant(.default))
	}
}
