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
	static let spacing = 23.0
	static let padding = 20.0
	static let sizeImage = 64.0
	static let paddingTop = 50.0
	static let sizeIcon = 18.0
	static let radius = 80.0
	static let paddingHorizontal = 80.0
	static let paddingButton = 12.0
	static let buttonSize = CGSize(width: 196.0, height: 40.0)
	static let paddingButtonNext = 48.0
}

struct AddMemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var loadable: Loadable<IGroupDetailViewModels>
	@Binding var search: [GroupDetailUserViewModels]
	@State private(set) var groupId: Int64 = 0
	@State private(set) var searchText: String = ""
	@State private(set) var severText: String = ""
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchLinkStyle: TextInputStyle = .default
	@State private(set) var isShowingView: Bool = false
	@State private(set) var isSelectedUser: Bool = false
	@State private(set) var addMember: [GroupDetailUserViewModels] = []
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		VStack(alignment: .center, spacing: Constants.spacing) {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				SearchTextField(searchText: $searchText,
								inputStyle: $searchStyle,
								inputIcon: AppTheme.shared.imageSet.searchIcon,
								placeHolder: "GroupDetail.Search".localized,
								onEditingChanged: { isEditing in
					searchStyle = isEditing ? .highlighted : .normal })
					.onChange(of: searchText) { text in
						search(text: text)
					}
				CheckBoxButtons(text: "GroupDetail.TitleCheckbox".localized, isChecked: $isShowingView)
					.foregroundColor(foregroundCheckmask)
			}
			if isShowingView {
				VStack(alignment: .center) {
					CommonTextField(text: $severText,
									inputStyle: $searchLinkStyle,
									placeHolder: "GroupDetail.Title.PlaceHoder".localized,
									onEditingChanged: { isEditing in
						searchLinkStyle = isEditing ? .highlighted : .normal })
						.frame(maxHeight: .infinity, alignment: .top)
					Spacer()
				}
			} else {
				ScrollView(showsIndicators: false) {
					ForEach($search) { item in
						UserGroupButton(item.displayName, imageUrl: "", action: { addClient(item.wrappedValue) })
					}
				}
			}
			RoundedGradientButton("General.Next".localized, disabled: .constant(self.addMember.isEmpty), action: nextAction)
				.frame(width: Constants.buttonSize.width)
				.padding(.bottom, Constants.paddingButtonNext)
			
		}
		.padding(.horizontal, Constants.padding)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.applyNavigationBarPlainStyle(title: "GroupDetail.AddMember".localized,
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

// MARK: - Private
private extension AddMemberView {
	
}

// MARK: - Private Variables
private extension AddMemberView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundCheckmask: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
	
	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.background, AppTheme.shared.colorSet.background] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
	
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension AddMemberView {
	
	func addClient(_ data: GroupDetailUserViewModels) {
		isSelectedUser.toggle()
		if isSelectedUser == true {
			addMember.append(data)
		} else {
			let memberdata = addMember.filter { $0.displayName != data.displayName }
			self.addMember = memberdata
		}
	}
}

// MARK: - Loading Content
private extension AddMemberView {
	
}

// MARK: - Interactor
private extension AddMemberView {
	func search(text: String) {
		Task {
			loadable = await injected.interactors.groupDetailInteractor.searchUser(keyword: text, groupId: groupId )
		}
	}
	
	func customBack() {
		Task {
			loadable = await injected.interactors.groupDetailInteractor.getGroup(by: groupId)
		}
	}
	
	func nextAction() {
		addMember.forEach { member in
			Task {
				loadable = await injected.interactors.groupDetailInteractor.addMember(member, groupId: groupId)
			}
		}
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct AddMemberView_Previews: PreviewProvider {
	static var previews: some View {
		AddMemberView(loadable: .constant(.notRequested), search: .constant([]))
	}
}
#endif
