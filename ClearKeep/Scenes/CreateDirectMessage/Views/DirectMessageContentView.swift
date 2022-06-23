//
//  DirectMessageContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
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
	static let radius = 80.0
	static let paddingHorizontal = 80.0
	static let paddingButton = 12.0
}

struct DirectMessageContentView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var searchText: String = ""
	@State private(set) var severText: String = ""
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var isShowingLinkUser: Bool = false
	@Binding var loadable: Loadable<CreatePeerViewModels>
	@Binding var userData: [CreatePeerUserViewModel]
	@State private(set) var idUser: String = ""
	
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		NavigationView {
			content
				.background(backgroundColorView)
				.edgesIgnoringSafeArea(.all)
				.hiddenNavigationBarStyle()
				.applyNavigationBarPlainStyle(title: "DirectMessages.TitleButton".localized,
											  titleColor: titleColor,
											  backgroundColors: backgroundButtonBack,
											  leftBarItems: {
					BackButtonStandard(customBack)
				},
											  rightBarItems: {
					Spacer()
				})
		}
	}
}

// MARK: - Private
private extension DirectMessageContentView {
	var content: AnyView {
		AnyView(contentView)
	}

	var addSeverTextfield: AnyView {
		AnyView(addSeverTextfieldView)
	}
}

// MARK: - Private Variables
private extension DirectMessageContentView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var backgroundButtonImage: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}

	var backgroundNextButton: LinearGradient {
		colorScheme == .light ? backgroundButtonImage : backgroundButtonImage
	}

	var foregroundCheckmask: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension DirectMessageContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func nextAction() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.createDirectMessageInteractor.createGroup(by: idUser, groupName: userData.first?.displayName ?? "", groupType: "peer", lstClient: userData)
		}
	}

	func search(text: String) {
		Task {
			loadable = await injected.interactors.createDirectMessageInteractor.searchUser(keyword: text)
		}
	}
}

// MARK: - Loading Content
private extension DirectMessageContentView {
	var contentView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			SearchTextField(searchText: $searchText,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.searchIcon,
							placeHolder: "General.Search".localized,
							onEditingChanged: { isEditing in
				inputStyle = isEditing ? .highlighted : .normal })
				.onChange(of: searchText) { text in
					search(text: text)
				}
			CheckBoxButtons(text: "DirectMessages.AddUserTitle".localized, isChecked: $isShowingLinkUser)
				.foregroundColor(foregroundCheckmask)
			if isShowingLinkUser {
				addSeverTextfieldView
			} else {
				userView
			}
			Spacer()
		}
		.padding([.horizontal, .bottom], Constants.padding)
	}

	var userView: some View {
		ScrollView(showsIndicators: false) {
			ForEach($userData, id: \.id) { item in
				UserPeerButton(item.displayName, imageUrl: "", action: nextAction)
			}
		}
	}

	var addSeverTextfieldView: some View {
		VStack {
			CommonTextField(text: $severText,
							inputStyle: $inputStyle,
							placeHolder: "DirectMessages.LinkTitle".localized,
							onEditingChanged: { _ in })
			Spacer()
			Button(action: nextAction) {
				HStack(spacing: Constants.spacing) {
					Text("DirectMessages.Next".localized)
						.padding(.vertical, Constants.paddingButton)
						.padding(.horizontal, Constants.paddingHorizontal)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
						.cornerRadius(Constants.radius)
				}
			}
			.background(backgroundNextButton)
			.cornerRadius(Constants.radius)
		}
	}
}

// MARK: - Interactor
private extension DirectMessageContentView {
}

// MARK: - Preview
#if DEBUG
struct DirectMessageContentView_Previews: PreviewProvider {
	static var previews: some View {
		DirectMessageContentView(loadable: .constant(.notRequested), userData: .constant([]))
	}
}
#endif
