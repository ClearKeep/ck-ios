//
//  HomeMenuView.swift
//  ClearKeep
//
//  Created by MinhDev on 11/03/2022.
//

import SwiftUI

struct HomeMenuView: View {
	var body: some View {
		VStack {
			Group {
				AppTheme.shared.imageSet.crossIcon
					.resizable()
					.padding(.trailing, 20.0)
				HStack {
					AppTheme.shared.imageSet.googleIcon
					VStack{
						Text("Test")
						HStack {
							Text("Test")
							AppTheme.shared.imageSet.chevUpIcon
						}
						HStack {
							Text("Test")
							AppTheme.shared.imageSet.copyIcon
						}
					}
				}
				Divider()
			}
			content
		}
	}
}
// MARK: - Loading Content
private extension HomeMenuView {
	var content: AnyView {
		AnyView(listView)
	}
	var listView: some View {
		HStack {
			AppTheme.shared.imageSet.userIcon
			Text("Profile")
		}
	}
}
struct HomeMenuView_Previews: PreviewProvider {
	static var previews: some View {
		HomeMenuView()
	}
}
