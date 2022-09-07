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
	static let spacerTopView = 90.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let paddingVertical = 14.0
}

struct AddMemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var loadable: Loadable<IGroupDetailViewModels>
	@Binding var search: [GroupDetailUserViewModels]
	@State private(set) var loadableUrl: Loadable<IGroupDetailViewModels> = .notRequested {
		didSet {
			switch loadableUrl {
			case .loaded(let load):
				isLoading = false
				let data = load.profileWithLink
				let user = GroupDetailUserViewModels(id: data?.id ?? "", displayName: data?.displayName ?? "", workspaceDomain: data?.workspaceDomain ?? "", avatar: data?.avatar ?? "" )
				if !addMember.contains(where: { $0.id == user.id }) {
					self.addMember.append(user)
					searchLinkText = ""
				}
			case .failed(let error):
				isLoading = false
				self.error = GroupDetailErrorView(error)
				self.isShowError = true
			case .isLoading:
				isLoading = true
			default: break
			}
		}
	}

	@State private(set) var groupId: Int64 = 0
	@State private(set) var searchText: String = ""
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchLinkText: String = ""
	@State private(set) var searchLinkStyle: TextInputStyle = .default
	@State private(set) var searchEmailText: String = ""
	@State private(set) var searchEmailStyle: TextInputStyle = .default
	@State private(set) var isSelectedUser: Bool = false
	@State private(set) var addMember: [GroupDetailUserViewModels] = []
	@State private(set) var useCustomServerChecked: Bool = false
	@State private var isNextCreateGroup: Bool = false
	@State private var messageAlert: String = ""
	@State private var isShowAlert: Bool = false
	@State private var useFindByEmail: Bool = false
	@State private var isLoading: Bool = false
	@State private var error: GroupDetailErrorView?
	@State private var isShowError: Bool = false

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
					.padding(.top, Constants.paddingVertical)
				TagDetailView(groupDetaiModel: $addMember, deleteSelect: { data in
					self.deleteClient(data: data)
				})
				CheckBoxButtons(text: "GroupDetail.TitleCheckbox".localized, isChecked: $useCustomServerChecked)
					.foregroundColor(foregroundCheckmask)
			}
			if useCustomServerChecked {
				CommonTextField(text: $searchLinkText,
								inputStyle: $searchLinkStyle,
								placeHolder: "GroupDetail.Title.PlaceHoder".localized,
								onEditingChanged: { isEditing in
					searchLinkStyle = isEditing ? .highlighted : .normal },
								submitLabel: .done,
								onSubmit: addUserWithLink)
			}
			CheckBoxButtons(text: "GroupChat.AddUserFromEmail.Title".localized, isChecked: $useFindByEmail, action: {
				self.useCustomServerChecked = false
			})
				.foregroundColor(foregroundCheckmask)
				.frame(maxWidth: .infinity, alignment: .leading)
			if useFindByEmail {
				CommonTextField(text: $searchEmailText,
								inputStyle: $searchEmailStyle,
								placeHolder: "GroupChat.PasteYourFriendEmail".localized,
								keyboardType: .emailAddress,
								onEditingChanged: { isEditing in
					searchEmailStyle = isEditing ? .highlighted : .normal
				},
								submitLabel: .done,
								onSubmit: searchEmail)
			}
			ScrollView(showsIndicators: false) {
				ForEach($search) { item in
					UserGroupButton(item.displayName, imageUrl: item.avatar.wrappedValue, isChecked: self.checkUserIsSelected(item: item.wrappedValue), action: { isSelectedUser in
						addClient(item.wrappedValue, isSelected: isSelectedUser)
					})
				}
			}.progressHUD(isLoading)
			RoundedGradientButton(textButton, disabled: .constant(self.checkDisableButton()), action: nextToCreateGroup)
				.frame(maxWidth: .infinity)
				.frame(height: Constants.heightButton)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.background(backgroundGradientPrimary)
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
				.cornerRadius(Constants.cornerRadiusButtonNext)
				.padding(.horizontal, Constants.spacerTopView)
				.padding(.bottom, 57)
		}
		.padding(.horizontal, Constants.padding)
		.applyNavigationBarPlainStyle(title: "GroupDetail.AddMember".localized,
									  titleColor: titleColor,
									  backgroundColors: backgroundButtonBack,
									  leftBarItems: {
			BackButtonStandard(customBack)
		},
									  rightBarItems: {
			Spacer()
		})
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.alert(isPresented: self.$isShowAlert) {
			Alert(title: Text("General.Warning".localized),
				  message: Text(self.messageAlert),
				  dismissButton: .default(Text("General.OK".localized)))
		}
		.alert(isPresented: $isShowError) {
			Alert(title: Text(self.error?.title ?? ""),
				  message: Text(self.error?.message ?? ""),
				  dismissButton: .default(Text(error?.primaryButtonTitle ?? "")))
		}
		.onAppear(perform: notloaded)
	}
}

// MARK: - Private
private extension AddMemberView {

	var textButton: String {
		return useCustomServerChecked == false ? "General.Next".localized : "General.Add".localized
	}
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

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Private func
private extension AddMemberView {
	func addClient(_ data: GroupDetailUserViewModels, isSelected: Bool) {
		if isSelected,
		   self.addMember.firstIndex(where: { data.id == $0.id }) == nil {
			addMember.append(data)
			return
		}

		if !isSelected {
			self.deleteClient(data: data)
		}
	}

	func deleteClient(data: GroupDetailUserViewModels) {
		guard let index = self.addMember.firstIndex(where: { data.id == $0.id }) else {
			return
		}
		addMember.remove(at: index)
	}

	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)? {
		let args = link.split(separator: "/")
		if args.count != 3 {
			return nil
		}

		return (String(args[2]), String(args[1]), String(args[0]))
	}

	func checkUserIsSelected(item: GroupDetailUserViewModels) -> Bool {
		return self.addMember.contains(where: { $0.id == item.id })
	}
	
	private func checkDisableButton() -> Bool {
		if self.useCustomServerChecked {
			if self.searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				return true
			}
			
			guard let first = searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":").first,
				  let last = searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":").last else {
				return true
			}
			
			let validated = first.textFieldValidatorURL() && (first != last) && searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines).last != ":"
			if !validated {
				return true
			}
			
			if searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "/").count != 3 {
				return true
			}
			
			return false
		}
		
		if self.useFindByEmail {
			if self.searchEmailText.isEmpty {
				return true
			}
			
			return false
		}
		
		return addMember.isEmpty
	}
}

// MARK: - Interactor
private extension AddMemberView {
	func search(text: String) {
		if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			loadable = .loaded(GroupDetailViewModels(searchUser: []))
			return
		}
		Task {
			loadable = await injected.interactors.groupDetailInteractor.searchUser(keyword: text, groupId: groupId)
		}
	}

	func customBack() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.groupDetailInteractor.getClientInGroup(by: groupId)
		}
	}

	private func addUserWithLink() {
		if !injected.interactors.groupDetailInteractor.checkPeopleLink(link: searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines)) {
			let people = injected.interactors.groupDetailInteractor.getPeopleFromLink(link: searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines))
			loadableUrl = .isLoading(last: nil, cancelBag: CancelBag())
			Task {
				loadableUrl = await self.injected.interactors.groupDetailInteractor.getUserInfor(clientId: people?.id ?? "", workSpace: people?.domain ?? "")
			}
		} else {
			self.messageAlert = "GroupChat.YouCantCreateConversationWithYouSelf".localized
			self.isShowAlert = true
			self.searchLinkText = ""
			self.useCustomServerChecked = false
		}
	}

	private func searchEmail() {
		if !searchEmailText.trimmingCharacters(in: .whitespacesAndNewlines).validEmail {
			self.messageAlert = "GroupChat.EmailIsIncorrect".localized
			self.isShowAlert = true
			return
		}
		
		Task {
			loadable = await self.injected.interactors.groupDetailInteractor.searchUserWithEmail(email: searchEmailText.trimmingCharacters(in: .whitespacesAndNewlines))

		}
	}

	func nextToCreateGroup() {
		if self.useCustomServerChecked {
			self.addUserWithLink()
			return
		}

		if self.addMember.isEmpty {
			return
		}
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		addMember.forEach { user in
			Task {
				loadable = await self.injected.interactors.groupDetailInteractor.addMember(user, groupId: groupId)
				loadable = await injected.interactors.groupDetailInteractor.getClientInGroup(by: groupId)
			}
		}
	}

	func notloaded() {
		loadable = .loaded(GroupDetailViewModels(searchUser: []))
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
