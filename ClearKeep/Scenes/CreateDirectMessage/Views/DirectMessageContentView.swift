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
	@State private(set) var searchLinkText: String = ""
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var inputLinkStyle: TextInputStyle = .default
	@State private(set) var inputEmailStyle: TextInputStyle = .default
	@State private(set) var isShowingLinkUser: Bool = false
	@Binding var loadable: Loadable<ICreatePeerViewModels>
	@Binding var userData: [CreatePeerUserViewModel]
	@Binding var profile: CreatePeerProfileViewModel?
	@State private(set) var clientInGroup: [CreatePeerUserViewModel] = []
	@Binding var searchText: String
	@State private var messageAlert: String = ""
	@State private var isShowAlert: Bool = false
	@State private var useFindByEmail: Bool = false
	@State private var searchEmailText: String = ""
	let groups: [GroupViewModel]
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
					search(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
				}
			CheckBoxButtons(text: "DirectMessages.AddUserTitle".localized, isChecked: $isShowingLinkUser, action: {
				self.useFindByEmail = false
				self.searchEmailText = ""
			})
				.foregroundColor(foregroundCheckmask)
			
			if isShowingLinkUser {
				VStack {
					CommonTextField(text: $searchLinkText,
									inputStyle: $inputLinkStyle,
									placeHolder: "DirectMessages.LinkTitle".localized,
									onEditingChanged: { isEditing in
						inputLinkStyle = isEditing ? .highlighted : .normal
					})
				}
			}
			
			CheckBoxButtons(text: "GroupChat.AddUserFromEmail.Title".localized, isChecked: $useFindByEmail, action: {
				self.isShowingLinkUser = false
				self.searchLinkText = ""
			})
			.foregroundColor(foregroundCheckmask)
			
			if useFindByEmail {
				CommonTextField(text: $searchEmailText,
								inputStyle: $inputEmailStyle,
								placeHolder: "GroupChat.PasteYourFriendEmail".localized,
								onEditingChanged: { isEditing in
					inputEmailStyle = isEditing ? .highlighted : .normal
				},
								submitLabel: .done,
								onSubmit: searchEmail)
			}
			
			if !isShowingLinkUser {
				ScrollView(showsIndicators: false) {
					ForEach(userData) { item in
						UserPeerButton(item.displayName, imageUrl: "", action: { nextAction(item) })
					}
				}
			}
			
			if isShowingLinkUser || useFindByEmail {
				Spacer()
				VStack {
					RoundedGradientButton("DirectMessages.Next".localized,
										  disabled: .constant(self.checkDisableButton()),
										  action: createUserByLink)
					.frame(width: Constants.buttonSize.width)
					.padding(.bottom, Constants.paddingButtonNext)
				}.frame(maxWidth: .infinity)
			}
		}
		.padding(.horizontal, Constants.padding)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.alert(isPresented: self.$isShowAlert) {
			Alert(title: Text("GroupChat.Warning".localized),
				  message: Text(self.messageAlert),
				  dismissButton: .default(Text("GroupChat.Ok".localized)))
		}
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
		if self.checkUserIsAdded(id: data.id) {
			return
		}
		
		clientInGroup.append(data)
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			var clientGroup = clientInGroup
			let profile = DependencyResolver.shared.channelStorage.currentServer?.profile
			let client = CreatePeerUserViewModel(id: profile?.userId ?? "", displayName: profile?.userName ?? "", workspaceDomain: DependencyResolver.shared.channelStorage.currentDomain)
			clientGroup.append(client)
			loadable = await injected.interactors.createDirectMessageInteractor.createGroup(by: profile?.userId ?? "fail", groupName: data.displayName, groupType: "peer", lstClient: clientGroup)
		}
	}

	func search(text: String) {
		Task {
			loadable = await injected.interactors.createDirectMessageInteractor.searchUser(keyword: text.trimmingCharacters(in: .whitespacesAndNewlines))
		}
	}
	
	func createUserByLink() {
		if !injected.interactors.createDirectMessageInteractor.checkPeopleLink(link: searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines)) {
			let people = injected.interactors.chatGroupInteractor.getPeopleFromLink(link: searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines))
			if self.checkUserIsAdded(id: people?.id ?? "") {
				return
			}
			loadable = .isLoading(last: nil, cancelBag: CancelBag())
			Task {
				let profile = DependencyResolver.shared.channelStorage.currentServer?.profile
				let client = CreatePeerUserViewModel(id: profile?.userId ?? "", displayName: profile?.userName ?? "", workspaceDomain: DependencyResolver.shared.channelStorage.currentDomain)
				let clientInGroup: [CreatePeerUserViewModel] = [client]
				loadable = await injected.interactors.createDirectMessageInteractor.createGroupWithOrtherLink(by: profile?.userId ?? "fail",
																											  groupName: "",
																											  groupType: "peer",
																											  lstClient: clientInGroup,
																											  clientIdOther: people?.id ?? "id",
																											  workSpace: people?.domain ?? "")
			}
		} else {
			self.messageAlert = "GroupChat.YouCantCreateConversationWithYouSelf".localized
			self.isShowAlert = true
			self.searchLinkText = ""
			self.isShowingLinkUser = false
		}
	}
	
	func searchEmail() {
		if !searchEmailText.trimmingCharacters(in: .whitespacesAndNewlines).validEmail {
			self.messageAlert = "GroupChat.EmailIsIncorrect".localized
			self.isShowAlert = true
			return
		}
		
		Task {
			loadable = await self.injected.interactors.createDirectMessageInteractor.searchUserWithEmail(email: searchEmailText.trimmingCharacters(in: .whitespacesAndNewlines))
		}
	}
	
	private func checkUserIsAdded(id: String) -> Bool {
		if let group = groups.first(where: { item in
			item.groupMembers.contains(where: { $0.userId == id })
		}) {
			loadable = .loaded(CreatePeerViewModels(creatGroup: CreatePeerChatViewModel(group)))
			return true
		}
		
		return false
	}
	
	private func checkDisableButton() -> Bool {
		if self.isShowingLinkUser {
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
			
			if self.searchLinkText.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "/").count != 3 {
				return true
			}
			
			return false
		}
		
		if self.useFindByEmail {
			if self.searchEmailText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				return true
			}
			
			return false
		}
		
		return true
	}
}

// MARK: - Interactor
private extension DirectMessageContentView {
}

// MARK: - Preview
#if DEBUG
struct DirectMessageContentView_Previews: PreviewProvider {
	static var previews: some View {
		DirectMessageContentView(loadable: .constant(.notRequested), userData: .constant([]), profile: .constant(nil), searchText: .constant(""), groups: [])
	}
}
#endif
