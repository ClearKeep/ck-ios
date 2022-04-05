//
//  RemoveMember.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let padding = 20.0
	static let sizeImage = 64.0
	static let paddingTop = 50.0
	static let sizeIcon = 18.0
}

struct RemoveMemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var searchText: String
	@Binding var inputStyle: TextInputStyle
	
	// MARK: - Init
	init(imageUser: Binding<Image>,
		 userName: Binding<String>,
		 searchText: Binding<String>,
		 inputStyle: Binding<TextInputStyle>) {
		self._imageUser = imageUser
		self._userName = userName
		self._searchText = searchText
		self._inputStyle = inputStyle
	}
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.padding)
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.background(backgroundColorView)
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension RemoveMemberView {
	var content: AnyView {
		AnyView(contentView)
	}
	
	var buttonBack: AnyView {
		AnyView(buttonBackView)
	}
	
	var groupDetail: AnyView {
		AnyView(groupDetailView)
	}
	
	var buttonDelete: AnyView {
		AnyView(buttonDeleteView)
	}
}

// MARK: - Private Variables
private extension RemoveMemberView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
	
	var foregroundDelete: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.errorDefault : AppTheme.shared.colorSet.primaryDefault
	}
}

// MARK: - Private func
private extension RemoveMemberView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func deleteUser() {
		
	}
}

// MARK: - Loading Content
private extension RemoveMemberView {
	var contentView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			buttonBack
				.padding(.top, Constants.paddingTop)
				.frame(maxWidth: .infinity, alignment: .leading)
			SearchTextField(searchText: $searchText,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.searchIcon,
							placeHolder: "General.Search".localized,
							onEditingChanged: { _ in })
			Text("GroupDetail.UserInitTitle".localized)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(foregroundColorTitle)
			groupDetail
			Spacer()
		}
	}
	
	var groupDetailView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			HStack {
				imageUser
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
				Text(userName)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorUserName)
				Spacer()
				AppTheme.shared.imageSet.crossIcon
					.resizable()
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeIcon)
					.foregroundColor(foregroundDelete)
			}
		}
	}
	
	var buttonDeleteView: some View {
		Button(action: deleteUser) {
			AppTheme.shared.imageSet.crossIcon
				.resizable()
				.renderingMode(.template)
				.aspectRatio(contentMode: .fit)
				.frame(width: Constants.sizeIcon)
				.foregroundColor(foregroundDelete)
		}
	}
	
	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacing) {
				AppTheme.shared.imageSet.chevleftIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text("GroupDetail.RemoveMember".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Interactor
private extension RemoveMemberView {
}

// MARK: - Preview
#if DEBUG
struct RemoveMemberView_Previews: PreviewProvider {
	static var previews: some View {
		RemoveMemberView(imageUser: .constant(Image("")), userName: .constant(""), searchText: .constant(""), inputStyle: .constant(.default))
	}
}
#endif
