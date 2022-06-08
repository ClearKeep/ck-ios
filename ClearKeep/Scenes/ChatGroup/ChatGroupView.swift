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

struct ChatGroupView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<CreatGroupViewModels> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let load):
				self.getUser = load.getUser ?? []
//				self.profile = [load.getProfiles?.viewModelUser].compactMap { member in
//					CreatGroupProfieViewModel(member)}

			case .failed(let error):
				print(error)
			default: break
			}
		}
	}
	@State private(set) var searchText: String = ""
	@State private(set) var searchLinkText: String = ""
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchLinkStyle: TextInputStyle = .default
	@State private(set) var isShowingView: Bool = false
	@State private(set) var isSelectedUser: Bool = false
	@State private var isNextCreateGroup: Bool = false
	@State private(set) var name: String = ""
	@State private(set) var getUser: [CreatGroupGetUsersViewModel] = []
	@State private(set) var profile: [CreatGroupProfieViewModel] = []
	@State private(set) var search: [CreatGroupGetUsersViewModel] = []
	@State private(set) var isSearch: Bool = false
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.paddingVertical)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.applyNavigationBarPlainStyle(title: "CreatGroup",
										  titleColor: titleColor,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				BackButtonStandard(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
			.onAppear(perform: getUsers)
	}
}

// MARK: - Private
private extension ChatGroupView {

	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(data)
		case .failed(let error):
			return AnyView(errorView(LoginViewError(error)))
		}
	}
}

// MARK: - Loading Content
private extension ChatGroupView {
	var notRequestedView: some View {
		VStack(spacing: Constants.paddingVertical) {
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
			}, onTextChanged: searchAction)
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
					if isEditing {
						searchLinkStyle = .highlighted
					} else {
						searchLinkStyle = .normal
					}
				})
					.frame(maxHeight: .infinity, alignment: .top)
				Spacer()
			} else {
				List($getUser, id: \.id) { item in
					ListUser(user: item, imageUrl: .constant(""), name: item.displayName)
				}
				.listStyle(PlainListStyle())
			}
			NavigationLink(
				destination: CreateGroupView(profile: $profile),
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

	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}

	func loadedView(_ data: CreatGroupViewModels) -> AnyView {
		if isSearch {
			return AnyView(ScrollView {
				notRequestedView
				listView(data)
			})
		} else {
		return AnyView(errorView(LoginViewError.unknownError(errorCode: nil)))
		}
	}

	func errorView(_ error: LoginViewError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
	}

	func listView(_ data: CreatGroupViewModels) -> some View {
		
		List(data.searchUser ?? [], id: \.id) { item in
			ListUser(user: .constant(item), imageUrl: .constant(""), name: .constant(item.displayName))
		}
		.listStyle(PlainListStyle())
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

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Interactors
private extension ChatGroupView {

	func getUsers() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.chatGroupInteractor.getUsers()
		}
	}

	func getProfile() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.chatGroupInteractor.getProfile()
		}
	}

	func searchAction(for searchText: String) {
		isSearch = true
		   if !searchText.isEmpty {
			   Task {
				  await injected.interactors.chatGroupInteractor.searchUser(keyword: searchText)
			   }

		   }
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
