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
	static let spacing = 23.0
	static let padding = 20.0
	static let sizeImage = 64.0
	static let paddingTop = 50.0
	static let sizeIcon = 18.0
	static let radius = 80.0
	static let paddingHorizontal = 80.0
	static let paddingButton = 12.0
	static let buttonSize = CGSize(width: 196.0, height: 40.0)
	static let paddingButtonNext = 60.0
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
	@Binding var loadable: Loadable<ICreatePeerViewModels>
	@Binding var userData: [CreatePeerUserViewModel]
	@State private(set) var profile: CreatePeerProfileViewModel?
	@State private(set) var clientInGroup: [CreatePeerUserViewModel] = []

	// MARK: - Init

	// MARK: - Body
	var body: some View {
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
				VStack {
					CommonTextField(text: $severText,
									inputStyle: $inputStyle,
									placeHolder: "DirectMessages.LinkTitle".localized,
									onEditingChanged: { _ in })
					Spacer()
					RoundedGradientButton("DirectMessages.Next".localized,
										  disabled: .constant(clientInGroup.isEmpty),
										  action: customBack)
						.frame(width: Constants.buttonSize.width)
						.padding(.bottom, Constants.paddingButtonNext)
				}
			} else {
				ScrollView(showsIndicators: false) {
					ForEach(userData) { item in
						UserPeerButton(item.displayName, imageUrl: "", action: { nextAction(item) })
					}
				}
			}
		}
		.padding(.horizontal, Constants.padding)
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

// MARK: - Private Variables
private extension DirectMessageContentView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
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

	func nextAction(_ data: CreatePeerUserViewModel) {
		clientInGroup.append(data)
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.createDirectMessageInteractor.createGroup(by: profile?.id ?? "fail", groupName: clientInGroup.first?.displayName ?? "", groupType: "peer", lstClient: clientInGroup)
		}
	}

	func search(text: String) {
		Task {
			loadable = await injected.interactors.createDirectMessageInteractor.searchUser(keyword: text)
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
