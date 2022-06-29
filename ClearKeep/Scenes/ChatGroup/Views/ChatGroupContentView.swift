//
//  ChatGroupContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 19/06/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let paddingButtonNext = 48.0
}

struct ChatGroupContentView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@Binding var loadable: Loadable<ICreatGroupViewModels>
	@Binding var search: [CreatGroupGetUsersViewModel]
	@Binding var getUser: [CreatGroupGetUsersViewModel]
	@Binding var getProfile: CreatGroupProfieViewModel?
	@State private(set) var addMember: [CreatGroupGetUsersViewModel] = []
	@State private(set) var searchText: String = ""
	@State private(set) var searchLinkText: String = ""
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchLinkStyle: TextInputStyle = .default
	@State private(set) var isShowingView: Bool = false
	@State private(set) var isSelectedUser: Bool = false
	@State private var isNextCreateGroup: Bool = false
	
	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.paddingVertical) {
			SearchTextField(searchText: $searchText,
							inputStyle: $searchStyle,
							inputIcon: AppTheme.shared.imageSet.searchIcon,
							placeHolder: "GroupChat.Search.Placeholder".localized,
							onEditingChanged: { isEditing in
				searchStyle = isEditing ? .highlighted : .normal })
				.onChange(of: searchText) { text in
					search(text: text)
				}
				.padding(.top, Constants.paddingVertical)
			TagView(groupChatModel: [GroupChatModel(name: "absbd", checked: false),
									 GroupChatModel(name: "mvxcvmkdfkgdf", checked: false),
									 GroupChatModel(name: "kdrgjkerkter", checked: false),
									 GroupChatModel(name: "absbd", checked: false),
									 GroupChatModel(name: "kkjgkegjrktekrtert", checked: false),
									 GroupChatModel(name: "sdkfskfksdf", checked: false),
									 GroupChatModel(name: "sldfksldfklwelr", checked: false),
									 GroupChatModel(name: "ewrlwkrlewkr", checked: false),
									 GroupChatModel(name: "dfgdfgdfg", checked: false)])
			CheckBoxButtons(text: "GroupChat.User.Add.Title".localized, isChecked: $isShowingView)
				.frame(maxWidth: .infinity, alignment: .leading)
			if isShowingView {
				CommonTextField(text: $searchLinkText,
								inputStyle: $searchLinkStyle,
								placeHolder: "GroupChat.User.Add.Placeholder".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					searchLinkStyle = isEditing ? .highlighted : .normal
				})
					.frame(maxHeight: .infinity, alignment: .top)
				Spacer()
			} else {
				ScrollView(showsIndicators: false) {
					ForEach($search) { item in
						UserGroupButton(item.displayName, imageUrl: "", action: { addClient(item.wrappedValue) })
					}
				}
			}
			NavigationLink(
				destination: CreateGroupView(loadable: $loadable, getProfile: $getProfile, clientInGroup: $addMember),
				isActive: $isNextCreateGroup,
				label: {
					Button(action: {
						nextToCreateGroup()
					},
						   label: {
						Text("GroupChat.Next".localized)
					})
						.frame(maxWidth: .infinity)
						.frame(height: Constants.heightButton)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.background(backgroundGradientPrimary)
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
						.cornerRadius(Constants.cornerRadiusButtonNext)
						.padding(.horizontal, Constants.spacerTopView)
				})
				.padding(.bottom, Constants.paddingButtonNext)
		}
		.padding(.horizontal, Constants.paddingVertical)
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private

// MARK: - Interactor
private extension ChatGroupContentView {
}

// MARK: - Private Func
private extension ChatGroupContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func nextToCreateGroup() {
		isNextCreateGroup.toggle()
	}
}

// MARK: - Color func
private extension ChatGroupContentView {
	var foregroundButtonBack: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}
	
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
	
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Interactors
private extension ChatGroupContentView {
	
	func search(text: String) {
		Task {
			loadable = await injected.interactors.chatGroupInteractor.searchUser(keyword: text)
		}
	}
	
	func addClient(_ data: CreatGroupGetUsersViewModel) {
		isSelectedUser.toggle()
		addMember.append(data)
	}
}

// MARK: - Preview
#if DEBUG
struct ChatGroupContentView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupContentView(loadable: .constant(.notRequested), search: .constant([]), getUser: .constant([]), getProfile: .constant(nil))
	}
}
#endif
