//
//  ChatGroupView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
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
	static let paddingButtonNext = 60.0
}

final class GroupChatData: ObservableObject {
	@Published var modelList: [GroupChatModel] = []

	init() {
		loadData()
	}

	func loadData() {
		modelList = [GroupChatModel(name: "absbd", checked: false),
					 GroupChatModel(name: "mvxcvmkdfkgdf", checked: false),
					 GroupChatModel(name: "kdrgjkerkter", checked: false),
					 GroupChatModel(name: "absbd", checked: false),
					 GroupChatModel(name: "kkjgkegjrktekrtert", checked: false),
					 GroupChatModel(name: "sdkfskfksdf", checked: false),
					 GroupChatModel(name: "sldfksldfklwelr", checked: false),
					 GroupChatModel(name: "ewrlwkrlewkr", checked: false),
					 GroupChatModel(name: "dfgdfgdfg", checked: false)]
	}

	func setCheckItem(model: GroupChatModel, isChecked: Bool) {
		let index = modelList.firstIndex(where: { item in
			item.id == model.id
		})

		if let index = index {
			modelList[index].checked = isChecked
		}
	}

	func getListUserChecked() -> [GroupChatModel] {
		return modelList.filter({ item in
			item.checked == true
		})
	}
}

struct ChatGroupView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IGroupChatModel]>
	@State private(set) var searchText: String
	@State private(set) var searchLinkText: String
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchLinkStyle: TextInputStyle = .default
	@State private(set) var isShowingView: Bool = false
	@State private(set) var isSelectedUser: Bool = false
	@State private var isNextCreateGroup: Bool = false
	@State private(set) var name: String = ""
	@StateObject private var groupChatData = GroupChatData()
	
	// MARK: - Init
	public init(samples: Loadable<[IGroupChatModel]> = .notRequested,
				searchText: String = "",
				searchLinkText: String = "") {
		_samples = .init(initialValue: samples)
		_searchText = .init(initialValue: searchText)
		_searchLinkText = .init(initialValue: searchLinkText)
		_searchStyle = .init(initialValue: searchStyle)
		_searchLinkStyle = .init(initialValue: searchLinkStyle)
	}
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			VStack(spacing: Constants.paddingVertical) {

				inputSearch
				tagUser
				checkbox

				if isShowingView {
					CommonTextField(text: $searchLinkText,
									inputStyle: $searchLinkStyle,
									placeHolder: "GroupChat.User.Add.Placeholder".localized,
									keyboardType: .default,
									onEditingChanged: { isEditing in
						if isEditing {
							searchLinkStyle = .highlighted
						} else {
							searchLinkStyle = .normal
						}
					})
						.frame(maxHeight: .infinity, alignment: .top)
					Spacer()
				} else {
					listUser
				}
				buttonNext
			}
			.padding(.horizontal, Constants.paddingVertical)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.applyNavigationBarPlainStyle(title: "",
										  titleColor: AppTheme.shared.colorSet.offWhite,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				buttonBackView
			},
										  rightBarItems: {
				Spacer()
			})
		}
	}
}

// MARK: - Private
private extension ChatGroupView {
	var buttonBack: AnyView {
		AnyView(buttonBackView)
	}
	
	var inputSearch: AnyView {
		AnyView(inputSearchView)
	}
	
	var tagUser: AnyView {
		AnyView(tagView)
	}

	var checkbox: AnyView {
		AnyView(checkboxListUser)
	}

	var listUser: AnyView {
		AnyView(listUserView)
	}

	var buttonNext: AnyView {
		AnyView(buttonNextView)
	}
}

// MARK: - Loading Content
private extension ChatGroupView {
	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacer) {
				AppTheme.shared.imageSet.chevleftIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundButtonBack)
				Text("GroupChat.Back.Button".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body1))
					.foregroundColor(foregroundButtonBack)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
	
	var inputSearchView: some View {
		SearchTextField(searchText: $searchText,
						inputStyle: $searchStyle,
						inputIcon: AppTheme.shared.imageSet.searchIcon,
						placeHolder: "GroupChat.Search.Placeholder".localized,
						onEditingChanged: { isEditing in
			if isEditing {
				searchStyle = .highlighted
			} else {
				searchStyle = .normal
			}
		})
			.padding(.top, Constants.paddingVertical)
	}
	
	var tagView: some View {
		TagView(groupChatModel: [GroupChatModel(name: "absbd", checked: false),
								 GroupChatModel(name: "mvxcvmkdfkgdf", checked: false),
								 GroupChatModel(name: "kdrgjkerkter", checked: false),
								 GroupChatModel(name: "absbd", checked: false),
								 GroupChatModel(name: "kkjgkegjrktekrtert", checked: false),
								 GroupChatModel(name: "sdkfskfksdf", checked: false),
								 GroupChatModel(name: "sldfksldfklwelr", checked: false),
								 GroupChatModel(name: "ewrlwkrlewkr", checked: false),
								 GroupChatModel(name: "dfgdfgdfg", checked: false)])
	}

	var checkboxListUser: some View {
		CheckBoxButtons(text: "GroupChat.User.Add.Title".localized, isChecked: $isShowingView)
			.frame(maxWidth: .infinity, alignment: .leading)
	}

	var listUserView: some View {
		List(groupChatData.modelList, id: \.id) { item in
				ListUser(userModel: item, groupData: groupChatData)
			}
			.listStyle(PlainListStyle())
	}

	var buttonNextView: some View {
		NavigationLink(
			destination: CreateGroupView(model: groupChatData.getListUserChecked()),
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
}

// MARK: - Interactor
private extension ChatGroupView {
}

// MARK: - Private Func
private extension ChatGroupView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func nextToCreateGroup() {
		isNextCreateGroup.toggle()
	}
}

// MARK: - Color func
private extension ChatGroupView {
	var foregroundButtonBack: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}
	
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
}

// MARK: - Preview
#if DEBUG
struct ChatGroupView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupView()
	}
}
#endif
