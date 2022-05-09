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
	static let paddingTop = 76.0
	static let paddingLeading = 90.0
	static let padding = 16.0
	static let sizeOffset = 30.0
	static let sizeIcon = 24.0
	static let spacingTop = 25.0
}

struct HomeHeaderView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var searchText: String = ""
	@State private(set) var titleServer: String = "CK Development"
	@Binding var inputStyle: TextInputStyle
	@State private(set) var isMenuAction: Bool = false
	@State private(set) var isSearchAction: Bool = false
	@State private(set) var isAddServer: Bool = false
	
	// MARK: - Init
	init(inputStyle: Binding<TextInputStyle>) {
		self._inputStyle = inputStyle
	}
	
	// MARK: - Body
	var body: some View {
		content
			.background(backgroundColorView)
			.edgesIgnoringSafeArea(.all)
			.modifier(NavigationModifier())
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
	
	var homeContent: AnyView {
		isSearchAction ? AnyView(searchContentView) : AnyView(homeContentView)
	}
	
	var searchContent: AnyView {
		AnyView(searchContentView)
	}
	
	var bodyContent: AnyView {
		isAddServer ? AnyView(addServerView) : AnyView(bodyView)
	}
}

// MARK: - Private variable
private extension HomeHeaderView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
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
	
	var leaddingPadding: CGFloat {
		isSearchAction ? Constants.padding : Constants.paddingLeading
	}
	
	var iconSeachChange: Image {
		isSearchAction ? AppTheme.shared.imageSet.crossIcon : AppTheme.shared.imageSet.menuIcon
	}
	
	var placeHolderText: String {
		isSearchAction ? "Search.Placehodel".localized : "General.Search".localized
	}
	
	var titleText: String {
		isAddServer ? "JoinServer.Title".localized : titleServer
	}
}

// MARK: - Private func
private extension HomeHeaderView {
	func menuAction() {
		if isSearchAction == true {
			self.isSearchAction.toggle()
		} else {
			self.isMenuAction.toggle()
		}
	}
	
	func searchAction() {
		self.isSearchAction.toggle()
	}
}

// MARK: - Displaying Content
private extension HomeHeaderView {
	var contentView: some View {
		GeometryReader { geometry in
			ZStack {
				ServerView(isAddServer: $isAddServer)
					.frame(width: geometry.size.width)
					.offset(x: self.isSearchAction ? -geometry.size.width : 0 )
					.animation(.default)
				header
				HomeMenuView(isExpand: false, isShow: false, isChangeStatus: false, isMenuAction: $isMenuAction)
					.frame(width: geometry.size.width)
					.offset(x: self.isMenuAction ? 0 : geometry.size.width )
					.animation(.default)
			}
			.hideKeyboardOnTapped()
		}
	}
	
	var headerView: some View {
		VStack(alignment: .center) {
			HStack {
				Text(titleText)
					.font(AppTheme.shared.fontSet.font(style: .display3))
					.foregroundColor(foregroundColorTitle)
				Spacer()
				Button(action: menuAction) {
					iconSeachChange
						.resizable()
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
						.foregroundColor(foregroundColorTitle)
				}
			}
			.padding(.leading, leaddingPadding)
			.padding(.trailing, Constants.padding)
			bodyContent
				.padding(.top, Constants.spacingTop)
			Spacer()
			
		}
		.padding(.top, Constants.paddingTop)
	}
	
	var bodyView: some View {
		VStack(alignment: .center) {
			SearchTextField(searchText: $searchText,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.searchIcon,
							placeHolder: placeHolderText,
							onEditingChanged: { isEditing in
				if isEditing {
					inputStyle = .highlighted
					isSearchAction = true
				} else {
					inputStyle = .normal
				}
			})
				.padding(.leading, leaddingPadding)
				.padding(.trailing, Constants.padding)
			homeContent
		}
	}
	
	var homeContentView: some View {
		HomeContentView(isExpandGroup: false, isExpandMessage: false, isAddAction: false, isChangeStatus: false)
			.padding(.leading, leaddingPadding)
			.padding(.trailing, Constants.padding)
			.padding(.top, Constants.spacingTop)
	}
	
	var searchContentView: some View {
		SearchView(isSearchAction: $isSearchAction, searchText: $searchText)
	}
	
	var addServerView: some View {
		AddServerView()
			.padding(.leading, leaddingPadding)
	}
}

// MARK: - Preview
#if DEBUG
struct HomeHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		HomeHeaderView(inputStyle: .constant(.default))
	}
}
#endif
