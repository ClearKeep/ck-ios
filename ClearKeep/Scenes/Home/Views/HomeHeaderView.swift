//
//  HomeHeaderView.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let paddingLeading = 100.0
	static let padding = 20.0
	static let sizeOffset = 30.0
	static let sizeIcon = 24.0
}

struct HomeHeaderView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Binding var searchText: String
	@Binding var inputStyle: TextInputStyle
	@State private(set) var isMenuAction: Bool

	// MARK: - Init
	init(searchText: Binding<String>,
		 inputStyle: Binding<TextInputStyle>,
		 isMenuAction: Bool) {
		self._searchText = searchText
		self._inputStyle = inputStyle
		self._isMenuAction = .init(initialValue: isMenuAction)
	}
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			content
				.background(backgroundColorView)
				.edgesIgnoringSafeArea(.all)
				.navigationBarTitle("")
				.navigationBarHidden(true)
		}
	}
}

// MARK: - Private
private extension HomeHeaderView {
	var content: AnyView {
		AnyView(contentView)
	}

	var header: AnyView {
		AnyView(headerView)
	}
}

// MARK: - Private variable
private extension HomeHeaderView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.black
	}

	var backgroundColor: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private func
private extension HomeHeaderView {
	func menuAction() {
		self.isMenuAction.toggle()
	}
}

// MARK: - Displaying Content
private extension HomeHeaderView {
	var contentView: some View {
		GeometryReader { geometry in
			ZStack {
				ServerView(isChangeSever: false)
				header
				HomeMenuView(userName: "Test", urlString: "test", isExpand: false, isShow: true, isChangeStatus: true, isMenuAction: $isMenuAction)
					.frame(width: geometry.size.width)
					.offset(x: self.isMenuAction ? 0 : geometry.size.width )
					.animation(.default)
			}
		}
	}

	var headerView: some View {
		VStack {
			HStack {
				Text("Home.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .display3))
					.foregroundColor(foregroundColorTitle)
				Spacer()
				Button(action: menuAction) {
					AppTheme.shared.imageSet.menuIcon
						.resizable()
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
						.foregroundColor(foregroundColorTitle)
				}
			}
			SearchTextField(searchText: $searchText,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.searchIcon,
							placeHolder: "General.Search".localized,
							onEditingChanged: { _ in })
			HomeContentView(isExpandGroup: false, isExpandMessage: false, isAddAction: false, isChangeStatus: false)
			Spacer()
		}
		.padding(.top, Constants.paddingLeading)
		.padding(.leading, Constants.paddingLeading)
		.padding(.trailing, Constants.padding)
	}
}

// MARK: - Preview
#if DEBUG
struct HomeHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		HomeHeaderView(searchText: .constant("Test"), inputStyle: .constant(.default), isMenuAction: false)
	}
}
#endif
