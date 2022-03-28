//
//  AddMember.swift
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

struct AddMemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var searchText: String
	@Binding var inputStyle: TextInputStyle
	@State private(set) var isShowingView: Bool = false

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
private extension AddMemberView {
	var content: AnyView {
		AnyView(contentView)
	}

	var buttonBack: AnyView {
		AnyView(buttonBackView)
	}

	var buttonAdd: AnyView {
		AnyView(checkMaskButton)
	}
}

// MARK: - Private Variables
private extension AddMemberView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}

	var foregroundCheckmask: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension AddMemberView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Loading Content
private extension AddMemberView {
	var contentView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			buttonBack
				.padding(.top, Constants.paddingTop)
				.frame(maxWidth: .infinity, alignment: .leading)
			SearchTextField(searchText: $searchText,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.searchIcon,
							placeHolder: "GroupDetail.Search".localized,
							onEditingChanged: { _ in })
			buttonAdd
			if isShowingView {
				Text("GroupDetail.TitleCheckbox".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundBackButton)
					.frame(maxWidth: .infinity, alignment: .leading)

				Spacer()
			}
			Spacer()
		}
	}

	var checkMaskButton: some View {
		CheckBoxButtons(text: "GroupDetail.TitleCheckbox".localized, isChecked: $isShowingView)
			.foregroundColor(foregroundCheckmask)
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacing) {
				AppTheme.shared.imageSet.chevleftIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text("GroupDetail.AddMember".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Interactor
private extension AddMemberView {
}

// MARK: - Preview
#if DEBUG
struct AddMemberView_Previews: PreviewProvider {
	static var previews: some View {
		AddMemberView(imageUser: .constant(Image("")), userName: .constant(""), searchText: .constant(""), inputStyle: .constant(.default))
	}
}
#endif
