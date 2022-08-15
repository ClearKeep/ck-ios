//
//  RemoveMember.swift
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

struct RemoveMemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var loadable: Loadable<IGroupDetailViewModels>
	@Binding var member: [GroupDetailProfileViewModel]
	@State private(set) var groupData: [GroupDetailClientViewModel] = []
	@State private(set) var groupId: Int64 = 0
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchText: String = ""
	@State private var messageAlert: String = ""
	@State private var isShowAlert: Bool = false
	@State private var isShowPopUp: Bool = false
	
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		ScrollView(showsIndicators: false) {
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
				ForEach(member) { client in
					RemoveButtonView(.constant(client.displayName), imageUrl: client.avatar, action: {
						chosseUser(client) })
				}
			}
		}
		.padding(.horizontal, Constants.padding)
		.applyNavigationBarPlainStyle(title: "GroupDetail.RemoveMember".localized,
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
		.alert("GroupChat.Warning".localized, isPresented: $isShowPopUp) {
			Button("General.Cancel".localized, role: .cancel) { }
			Button("GroupDetail.Remove".localized, role: .none) { deleteUser() }
		} message: {
			Text(self.messagePopup)
		}
		.alert(isPresented: self.$isShowAlert) {
			Alert(title: Text("General.Success".localized),
				  message: Text(self.messageAlert),
				  dismissButton: .default(Text("GroupChat.Ok".localized), action: backAction))
		}
	}
}

// MARK: - Private
private extension RemoveMemberView {
	func backAction() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Private Variables
private extension RemoveMemberView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.background, AppTheme.shared.colorSet.background] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension RemoveMemberView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func chosseUser(_ data: GroupDetailProfileViewModel) {
		self.isShowPopUp = true
		self.groupData = groupData.filter { $0.id == data.id }
	}

	func deleteUser() {
		Task {
			do {
				let notification = try await injected.interactors.groupDetailInteractor.removeMember(groupData.first ?? GroupDetailClientViewModel(id: "", userName: "", domain: "", userState: "", userStatus: .undefined, phoneNumber: "", avatar: "", email: ""), groupId: groupId).get().groupBase?.error ?? "General.Error".localized
				self.messageAlert = notification.isEmpty ? "General.Error" .localized: "GroupDetail.Success.Remove".localized
				self.isShowAlert = true
			} catch {
				self.messageAlert = "General.Error".localized
				self.isShowAlert = true
			}
		}
	}

	func search(text: String) {
		self.member = member.filter { $0.displayName.lowercased().prefix(1) == text.lowercased().prefix(1) }
	}

	var messagePopup: String {
		String(format: "GroupDetail.LeadMesage.Remove".localized, groupData.first?.userName ?? "")
	}
}

// MARK: - Loading Content
private extension RemoveMemberView {

}

// MARK: - Interactor
private extension RemoveMemberView {
}
