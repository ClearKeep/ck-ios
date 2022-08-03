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
import Model

private enum Constants {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let paddingButtonNext = 48.0
	static let buttonSize = CGSize(width: 196.0, height: 40.0)
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
	@Binding var addMember: [CreatGroupGetUsersViewModel]
	@Binding var searchText: String
	@State private(set) var searchLinkText: String = ""
	@State private(set) var searchEmailText: String = ""
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchLinkStyle: TextInputStyle = .default
	@State private(set) var searchEmailStyle: TextInputStyle = .default
	@State private(set) var useCustomServerChecked: Bool = false
	@State private var isNextCreateGroup: Bool = false
	@State private var messageAlert: String = ""
	@State private var isShowAlert: Bool = false
	@State private var useFindByEmail: Bool = false
	
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
					search(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
				}
				.padding(.top, Constants.paddingVertical)
			TagView(groupChatModel: $addMember, deleteSelect: { data in
				self.deleteClient(data: data)
			})
			CheckBoxButtons(text: "GroupChat.User.Add.Title".localized, isChecked: $useCustomServerChecked, action: {
				self.useFindByEmail = false
			})
			.foregroundColor(foregroundCheckmask)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			if useCustomServerChecked {
				CommonTextField(text: $searchLinkText,
								inputStyle: $searchLinkStyle,
								placeHolder: "GroupChat.User.Add.Placeholder".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					searchLinkStyle = isEditing ? .highlighted : .normal
				})
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
					   UserGroupButton(item.displayName, imageUrl: "", isChecked: self.checkUserIsSelected(item: item.wrappedValue), action: { isSelectedUser in
						   addClient(item.wrappedValue, isSelected: isSelectedUser)
					   })
				   }
			   }
			
			RoundedGradientButton(self.useCustomServerChecked ? "GroupChat.Add".localized : "GroupChat.Next".localized, disabled: .constant(addMember.isEmpty && searchLinkText.isEmpty), action: nextToCreateGroup)
			.frame(maxWidth: .infinity)
			.frame(height: Constants.heightButton)
			.font(AppTheme.shared.fontSet.font(style: .body3))
			.background(backgroundGradientPrimary)
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
			.cornerRadius(Constants.cornerRadiusButtonNext)
			.padding(.horizontal, Constants.spacerTopView)
		}
		.padding(.horizontal, Constants.paddingVertical)
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.edgesIgnoringSafeArea(.all)
		.alert(isPresented: self.$isShowAlert) {
			Alert(title: Text("GroupChat.Warning".localized),
				  message: Text(self.messageAlert),
				  dismissButton: .default(Text("GroupChat.Ok".localized)))
		}.applyNavigationBarPlainStyle(title: "GroupChat.Back.Button".localized,
									   titleColor: titleColor,
									   backgroundColors: backgroundButtonBack,
									   leftBarItems: {
			BackButtonStandard(customBack)
		},
									   rightBarItems: {
			Spacer()
		})
		NavigationLink(
			destination: CreateGroupView(loadable: $loadable, getProfile: $getProfile, clientInGroup: $addMember),
			isActive: $isNextCreateGroup,
			label: {
			})
	}
}

// MARK: - Private
private extension ChatGroupContentView {
	func checkUserIsSelected(item: CreatGroupGetUsersViewModel) -> Bool {
		return self.addMember.contains(where: { $0.id == item.id })
	}
}

// MARK: - Interactor
private extension ChatGroupContentView {
}

// MARK: - Private Func
private extension ChatGroupContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func nextToCreateGroup() {
		if self.useCustomServerChecked {
			self.createGroupWithLink()
			return
		}
		
		if self.addMember.isEmpty {
			return
		}
		
		isNextCreateGroup = true
	}
	
	private func createGroupWithLink() {
		if !injected.interactors.chatGroupInteractor.checkPeopleLink(link: searchLinkText) {
			let people = injected.interactors.chatGroupInteractor.getPeopleFromLink(link: searchLinkText)
			loadable = .isLoading(last: nil, cancelBag: CancelBag())
			Task {
				loadable = await self.injected.interactors.chatGroupInteractor.getUserInfor(clientId: people?.id ?? "", workSpace: people?.domain ?? "")
			}
		} else {
			self.messageAlert = "GroupChat.YouCantCreateConversationWithYouSelf".localized
			self.isShowAlert = true
			self.searchLinkText = ""
			self.useCustomServerChecked = false
		}
	}
	
	private func searchEmail() {
		if searchEmailText.validEmail {
			Task {
				loadable = await self.injected.interactors.chatGroupInteractor.searchUserWithEmail(email: searchEmailText)
			}
		} else {
			self.messageAlert = "GroupChat.EmailIsIncorrect".localized
			self.isShowAlert = true
		}
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
	
	var foregroundCheckmask: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Interactors
private extension ChatGroupContentView {
	
	func search(text: String) {
		if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			loadable = .loaded(CreatGroupViewModels(searchUsers: []))
			return
		}
		Task {
			loadable = await injected.interactors.chatGroupInteractor.searchUser(keyword: text)
		}
	}
	
	func addClient(_ data: CreatGroupGetUsersViewModel, isSelected: Bool) {
		if isSelected,
		   self.addMember.firstIndex(where: { data.id == $0.id }) == nil {
			addMember.append(data)
			return
		}
		
		if !isSelected {
			self.deleteClient(data: data)
		}
	}
	
	func deleteClient(data: CreatGroupGetUsersViewModel) {
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
}

// MARK: - Preview
#if DEBUG
struct ChatGroupContentView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupContentView(loadable: .constant(.notRequested), search: .constant([]), getUser: .constant([]), getProfile: .constant(nil), addMember: .constant([]), searchText: .constant(""))
	}
}
#endif
